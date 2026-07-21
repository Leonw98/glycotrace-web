#!/usr/bin/env bash
#
# migrate-to-cf-pages.sh — move glycotrace.co.uk from GitHub Pages (origin)
# to Cloudflare Pages (direct upload), inside the existing Cloudflare zone.
#
# Current setup (verified 2026-07-21): Cloudflare proxy -> GitHub Pages origin.
# This script swaps the origin to a Cloudflare Pages project. DNS/registrar
# are untouched; only the record target changes, so rollback is trivial.
#
# NOTHING here prints your API token. Set it in the environment first:
#     export CLOUDFLARE_API_TOKEN=xxxxx     # scoped: Pages:Edit, DNS:Edit, Zone:Read
#     export CLOUDFLARE_ACCOUNT_ID=xxxxx    # optional; auto-discovered if unset
#
# Staged usage (run in order, verify between each):
#     ./migrate-to-cf-pages.sh preflight   # check token + tooling, show current DNS
#     ./migrate-to-cf-pages.sh deploy      # create project + upload -> preview URL
#     ./migrate-to-cf-pages.sh domain      # attach glycotrace.co.uk to the project
#     ./migrate-to-cf-pages.sh dns         # repoint the zone record (THE CUTOVER)
#     ./migrate-to-cf-pages.sh status      # show project, deployments, domains, DNS
#     ./migrate-to-cf-pages.sh rollback    # print how to revert to GitHub Pages
#
set -euo pipefail

PROJECT="glycotrace-web"
DOMAIN="glycotrace.co.uk"
PROD_BRANCH="master"
PAGES_HOST="${PROJECT}.pages.dev"

SITE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
API="https://api.cloudflare.com/client/v4"

# --- helpers -----------------------------------------------------------------

err()  { printf '\033[31m%s\033[0m\n' "$*" >&2; }
ok()   { printf '\033[32m%s\033[0m\n' "$*"; }
info() { printf '\033[36m%s\033[0m\n' "$*"; }

need_token() {
  : "${CLOUDFLARE_API_TOKEN:?Set CLOUDFLARE_API_TOKEN first (scoped: Pages:Edit, DNS:Edit, Zone:Read)}"
}

WRANGLER="wrangler"
command -v wrangler >/dev/null 2>&1 || WRANGLER="npx --yes wrangler"

# Parse JSON from stdin: jget "a.b.0.c"  (node is required and present)
jget() {
  node -e '
let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{
  let o; try{o=JSON.parse(s)}catch(e){process.exit(3)}
  const p=process.argv[1];
  let v=o; if(p) for(const k of p.split(".")){ if(v==null){v=undefined;break} v=/^\d+$/.test(k)?v[+k]:v[k]; }
  if(v===undefined||v===null) process.exit(0);
  process.stdout.write(typeof v==="object"?JSON.stringify(v):String(v));
})' "$1"
}

cf() { # cf METHOD PATH [JSON_BODY]
  local method="$1" path="$2" body="${3:-}"
  if [ -n "$body" ]; then
    curl -sS -X "$method" "${API}${path}" \
      -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
      -H "Content-Type: application/json" --data "$body"
  else
    curl -sS -X "$method" "${API}${path}" \
      -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
      -H "Content-Type: application/json"
  fi
}

discover_account() {
  if [ -n "${CLOUDFLARE_ACCOUNT_ID:-}" ]; then echo "$CLOUDFLARE_ACCOUNT_ID"; return; fi
  cf GET "/accounts?per_page=50" | jget "result.0.id"
}

zone_id() {
  cf GET "/zones?name=${DOMAIN}" | jget "result.0.id"
}

confirm() {
  local prompt="$1" reply
  printf '\033[33m%s\033[0m ' "$prompt"
  read -r reply
  [ "$reply" = "yes" ] || { err "Aborted (type 'yes' to proceed)."; exit 1; }
}

# --- commands ----------------------------------------------------------------

cmd_preflight() {
  need_token
  info "Verifying API token..."
  local v; v="$(cf GET "/user/tokens/verify" | jget "result.status")"
  [ "$v" = "active" ] && ok "Token active." || { err "Token not active (got: '$v'). Check scopes."; exit 1; }

  local acct; acct="$(discover_account)"
  [ -n "$acct" ] && ok "Account ID: $acct" || { err "Could not read account (needs Account Settings:Read, or set CLOUDFLARE_ACCOUNT_ID)."; }

  local zid; zid="$(zone_id)"
  [ -n "$zid" ] && ok "Zone ID for ${DOMAIN}: $zid" || { err "Zone ${DOMAIN} not found on this token (needs Zone:Read)."; exit 1; }

  info "Current DNS records for ${DOMAIN} (this is what points at GitHub Pages today):"
  cf GET "/zones/${zid}/dns_records?name=${DOMAIN}" \
    | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const r=JSON.parse(s).result||[];r.forEach(x=>console.log(`   ${x.type}\t${x.name}\t-> ${x.content}\tproxied=${x.proxied}\tid=${x.id}`));})'

  info "Wrangler: $($WRANGLER --version 2>/dev/null | head -1)"
  info "Site dir: ${SITE_DIR}"
  ok "Preflight OK. Next: ./migrate-to-cf-pages.sh deploy"
}

cmd_deploy() {
  need_token
  local acct; acct="$(discover_account)"
  export CLOUDFLARE_ACCOUNT_ID="$acct"

  # Create the direct-upload project if it does not exist yet (idempotent).
  local exists; exists="$(cf GET "/accounts/${acct}/pages/projects/${PROJECT}" | jget "result.name")"
  if [ "$exists" = "$PROJECT" ]; then
    ok "Pages project '${PROJECT}' already exists."
  else
    info "Creating direct-upload Pages project '${PROJECT}'..."
    cf POST "/accounts/${acct}/pages/projects" \
      "{\"name\":\"${PROJECT}\",\"production_branch\":\"${PROD_BRANCH}\"}" >/dev/null
    ok "Created."
  fi

  # Build a clean staging copy of ONLY the public site. wrangler pages deploy
  # does not honour .assetsignore, so we filter here with tar instead. This is
  # what guarantees internal docs / private zips / >25MiB files never ship.
  local stage="${SITE_DIR}/deploy/.staging"
  info "Building clean staging copy (excluding internal/private/oversized files)..."
  rm -rf "$stage"; mkdir -p "$stage"
  ( cd "$SITE_DIR" && tar \
      --exclude='./.git' --exclude='./.github' --exclude='./deploy' \
      --exclude='./node_modules' --exclude='./content-ideas' --exclude='./docs' \
      --exclude='*.md' --exclude='*.zip' --exclude='*.docx' \
      --exclude='*.sh' --exclude='*.py' --exclude='*.bat' --exclude='*.ps1' \
      --exclude='*.bundle' --exclude='*.original.*' \
      --exclude='./CNAME' --exclude='./.assetsignore' --exclude='./.gitignore' \
      -cf - . ) | ( cd "$stage" && tar -xf - )

  # Fail loudly if anything unwanted slipped through.
  local leak; leak="$(cd "$stage" && find . -type f \( -iname '*.md' -o -iname '*.zip' -o -iname '*.docx' -o -size +25M \) 2>/dev/null)"
  if [ -n "$leak" ]; then err "Staging still contains files it should not:"; printf '%s\n' "$leak" >&2; exit 1; fi
  info "Staging file count: $(cd "$stage" && find . -type f | wc -l). Deploying..."

  ( cd "$stage" && $WRANGLER pages deploy . \
      --project-name "$PROJECT" --branch "$PROD_BRANCH" --commit-dirty=true )

  echo
  ok "Preview is live. VERIFY IT BEFORE CUTOVER:"
  info "   https://${PAGES_HOST}/"
  info "   https://${PAGES_HOST}/type-3c-diabetes        (pillar; still noindex)"
  info "   https://${PAGES_HOST}/cgm-for-type-3c-diabetes"
  echo
  info "Confirm the internal docs are NOT served (should 404):"
  info "   https://${PAGES_HOST}/PILLAR_CLUSTER_PLAN.md"
  info "When happy: ./migrate-to-cf-pages.sh domain"
}

cmd_domain() {
  need_token
  local acct; acct="$(discover_account)"
  info "Attaching custom domain ${DOMAIN} to Pages project ${PROJECT}..."
  local out; out="$(cf POST "/accounts/${acct}/pages/projects/${PROJECT}/domains" "{\"name\":\"${DOMAIN}\"}")"
  local name; name="$(printf '%s' "$out" | jget "result.name")"
  if [ "$name" = "$DOMAIN" ]; then
    ok "Custom domain registered on the project (status: $(printf '%s' "$out" | jget "result.status"))."
  else
    err "Domain add response:"; printf '%s\n' "$out"
    err "If it says the domain already exists on the project, that is fine — continue."
  fi
  info "Next (the actual cutover): ./migrate-to-cf-pages.sh dns"
}

cmd_dns() {
  need_token
  local zid; zid="$(zone_id)"
  local recs; recs="$(cf GET "/zones/${zid}/dns_records?name=${DOMAIN}&per_page=100")"

  # ONLY website-routing records (A/AAAA/CNAME) get replaced. MX/TXT/etc.
  # (email + verification) are deliberately left untouched.
  local del_ids
  del_ids="$(printf '%s' "$recs" | node -e '
let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{
  const r=(JSON.parse(s).result||[]).filter(x=>["A","AAAA","CNAME"].includes(x.type));
  process.stdout.write(r.map(x=>x.id).join(" "));
})')"

  echo
  info "THIS IS THE CUTOVER. Repoints the website from GitHub Pages to Cloudflare Pages."
  info "WILL BE REPLACED (website routing):"
  printf '%s' "$recs" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{(JSON.parse(s).result||[]).filter(x=>["A","AAAA","CNAME"].includes(x.type)).forEach(x=>console.log("   - "+x.type+" -> "+x.content))})'
  info "WILL BE CREATED:"
  info "   + CNAME ${DOMAIN} -> ${PAGES_HOST} (proxied)"
  info "LEFT UNTOUCHED (email + verification):"
  printf '%s' "$recs" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{(JSON.parse(s).result||[]).filter(x=>!["A","AAAA","CNAME"].includes(x.type)).forEach(x=>console.log("   = "+x.type+" -> "+x.content))})'
  confirm "Type 'yes' to cut over now:"

  local id
  for id in $del_ids; do
    cf DELETE "/zones/${zid}/dns_records/${id}" | jget "success" | grep -q true \
      && ok "Removed old routing record ${id}" || err "Could not delete ${id} (continuing)"
  done

  local payload="{\"type\":\"CNAME\",\"name\":\"${DOMAIN}\",\"content\":\"${PAGES_HOST}\",\"proxied\":true,\"comment\":\"Cloudflare Pages origin (migrated from GitHub Pages)\"}"
  cf POST "/zones/${zid}/dns_records" "$payload" | jget "success" | grep -q true \
    && ok "Created CNAME ${DOMAIN} -> ${PAGES_HOST} (proxied)." \
    || { err "CNAME create failed — apex may still have a conflicting record. Check the dashboard."; exit 1; }

  ok "Cutover done. Give it a few minutes to propagate, then: ./migrate-to-cf-pages.sh status"
}

cmd_status() {
  need_token
  local acct; acct="$(discover_account)"; local zid; zid="$(zone_id)"
  info "Pages project:"
  cf GET "/accounts/${acct}/pages/projects/${PROJECT}" \
    | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const r=JSON.parse(s).result||{};console.log(`   name=${r.name} subdomain=${r.subdomain} domains=${(r.domains||[]).join(", ")}`);})'
  info "Latest deployment:"
  cf GET "/accounts/${acct}/pages/projects/${PROJECT}/deployments?per_page=1" \
    | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const d=(JSON.parse(s).result||[])[0]||{};console.log(`   ${d.created_on||"?"}  ${(d.latest_stage||{}).name||"?"}=${(d.latest_stage||{}).status||"?"}  ${d.url||""}`);})'
  info "Live headers (want cf-ray, and NO 'via: varnish'/x-served-by once cutover propagates):"
  curl -sS -I "https://${DOMAIN}/" 2>&1 | grep -iE 'server:|via:|x-served-by|cf-ray' | sed 's/^/   /'
}

cmd_rollback() {
  cat <<EOF
Rollback (revert to GitHub Pages):
  1. Delete the CNAME ${DOMAIN} -> ${PAGES_HOST}.
  2. Re-create the four GitHub Pages A records at the apex (all proxied / orange cloud):
       A  ${DOMAIN}  185.199.108.153
       A  ${DOMAIN}  185.199.109.153
       A  ${DOMAIN}  185.199.110.153
       A  ${DOMAIN}  185.199.111.153
  3. Optionally remove the custom domain from the Pages project.
  MX and TXT records were never changed, so email/verification are unaffected.
  Nothing at the registrar changes, so this reverts within minutes.
EOF
}

case "${1:-}" in
  preflight) cmd_preflight ;;
  deploy)    cmd_deploy ;;
  domain)    cmd_domain ;;
  dns)       cmd_dns ;;
  status)    cmd_status ;;
  rollback)  cmd_rollback ;;
  *) err "Usage: $0 {preflight|deploy|domain|dns|status|rollback}"; exit 2 ;;
esac
