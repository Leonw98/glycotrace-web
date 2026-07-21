# Deploy — GitHub Pages → Cloudflare Pages (direct upload)

Moves glycotrace.co.uk off the GitHub Pages origin onto a Cloudflare Pages
project, inside the Cloudflare zone that already fronts the domain. Only the
DNS record target changes; registrar and nameservers are untouched.

## One-time prerequisites

1. Mint a **scoped** API token at https://dash.cloudflare.com/profile/api-tokens
   (do NOT use the global key). Permissions:
   - Account → Cloudflare Pages → **Edit**
   - Zone → DNS → **Edit**  (zone: glycotrace.co.uk)
   - Zone → Zone → **Read**
   - (optional) Account → Account Settings → Read — lets the script auto-find the account id
2. Also delete the old leaked token flagged in memory (`cfat_…`).
3. Export it in your shell (the script never prints it):
   ```bash
   export CLOUDFLARE_API_TOKEN=xxxxx
   export CLOUDFLARE_ACCOUNT_ID=xxxxx   # optional; only if step-1 "Account Settings:Read" was skipped
   ```

## Run it (staged — verify between each step)

```bash
cd D:/src/glycotrace-web
./deploy/migrate-to-cf-pages.sh preflight   # verify token/tooling, show current DNS
./deploy/migrate-to-cf-pages.sh deploy      # create project + upload -> preview URL
#   ↳ open https://glycotrace-web.pages.dev and check it looks right,
#     and that https://glycotrace-web.pages.dev/PILLAR_CLUSTER_PLAN.md 404s
./deploy/migrate-to-cf-pages.sh domain      # attach glycotrace.co.uk to the project
./deploy/migrate-to-cf-pages.sh dns         # THE CUTOVER (asks you to type 'yes')
./deploy/migrate-to-cf-pages.sh status      # confirm 'via: varnish' is gone
```

Rollback any time: `./deploy/migrate-to-cf-pages.sh rollback`.

## Notes

- **`.assetsignore`** keeps internal docs (`*.md`, `content-ideas/`, `docs/`, `deploy/`)
  off the public site. Check `/PILLAR_CLUSTER_PLAN.md` 404s on the preview.
- **`_headers`** / **`_redirects`** are inert on GitHub Pages but activate on Pages.
- The pillar (`/type-3c-diabetes`) stays `noindex` regardless of host — flipping that
  is a separate, content-review-gated step.
- Future updates: `wrangler pages deploy . --project-name glycotrace-web --branch master`.
