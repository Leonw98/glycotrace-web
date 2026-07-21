# Pillar & Cluster Restructure Plan — Type 3c

**Status:** planned, not started. Execute in the glycotrace-web chat.
**Origin:** GSC (7 days to 2026-07-14) shows the head term `type 3c diabetes` at **position 85** with no page built to own it, while eleven strong Type 3c articles stand as a flat pile with only ad-hoc cross-links. The one bright spot is `cgm-for-type-3c-diabetes` at **position 9.5** (bottom of page 1).
**Goal:** one authoritative pillar page + a deliberate internal-link structure so Google reads the site as *the* Type 3c resource. One-time restructure, no ongoing labour — fits background mode.

---

## 1. The pillar page (NEW)

- **URL:** `/type-3c-diabetes` (clean, no `.html`; free — does not collide with `type-3c-diabetes-app` or `type-3c-vs-type-2-diabetes`).
- **Working title / H1:** "Type 3c diabetes: the complete guide"
- **Target head term:** `type 3c diabetes` (currently pos 85-89), plus `pancreatogenic diabetes`, `diabetes after pancreatitis` as secondary.
- **Real target queries (from 3-month GSC to 2026-07-14 — these are queries the site ALREADY appears for, all stuck at pos 70-98; use them verbatim as H2s / FAQ questions):**
  - `type 3c diabetes` (17 impr, pos 89 — the head term)
  - `what is type 3c diabetes` (pos 93)
  - `type 3c diabetes symptoms` (pos 88)
  - `type 3c diabetes causes` (pos 84)
  - `type 3c diabetes diagnosis` / `type 3c diabetes test` (pos 81 / 70)
  - `type 3c diabetes nhs` (pos 75)
  - `type 3c diabetes vs type 1` (pos 78) and vs type 2 (cluster article already at pos 15)
  - `is type 3c diabetes a recognised condition` / `type 3c diabetes is not a recognised condition` (pos 87) — clearly a real question people ask; answer it head-on
  - `pancreatogenic diabetes` (pos 86), `type 3c diabetes mellitus` (pos 92), `t3cdm` / `dm type 3c` (pos 90-93) — cover the terminology/synonyms explicitly
  - **NOTE:** `science.html` is currently absorbing 100 impressions at pos 45 as the accidental catch-all for all of the above. The pillar exists to take that demand and rank it properly; check the pillar out-ranks/replaces science.html for these terms after publish.
- **Role:** broad, authoritative overview that summarises every sub-topic in 2-4 paragraphs each, then hands off to the deep-dive article. It should be genuinely useful standing alone, NOT a thin table of contents (that would trip the STANDARDS/CLAUDE.md thin-content rail).
- **Section skeleton** (each section = a short summary + one inward link to the cluster article that goes deep):
  1. What Type 3c (pancreatogenic) diabetes is → links to `type-3c-vs-type-2-diabetes`
  2. What causes it (pancreatitis, pancreatic cancer, surgery, EPI) → links to `blood-sugar-after-pancreatitis`, `pancreatic-cancer-type-3c-diabetes`
  3. How it differs from Type 1 and Type 2 → links to `type-3c-vs-type-2-diabetes`, `specialized-vs-general`
  4. Diagnosis and why it's mis-diagnosed as Type 2 → links to `type-3c-vs-type-2-diabetes`
  5. Managing blood sugar day to day (CGM, time in range) → links to `cgm-for-type-3c-diabetes`, `time-in-range-type-3c`, `hot-weather-blood-sugar`
  6. Medication and GLP-1 questions → links to `glp1-type-3c-diabetes`
  7. Mental health / disordered eating risk → links to `diabulimia`
  8. Tools that help (soft CTA) → links to `best-app-type-3c-diabetes`, `type-3c-diabetes-app`
- **Schema:** follow the site's patient-not-clinician convention (Article + Organization publisher = LW Data Labs LTD; NO `MedicalWebPage`/`reviewedBy` — see the glycotrace-publish-without-clinician rule). Every clinical claim sourced.
- **Length target:** substantial (the deep pillar, likely the longest page on the site). It replaces nothing; `science.html` stays as-is.

---

## 2. Cluster map (existing articles — no rewrites, just re-link)

Three sub-clusters. Articles already mostly sit in these groups via their "Related reading" blocks; the change is making every one point UP to the pillar and tightening sibling links.

**A. Understanding & diagnosis**
- `type-3c-vs-type-2-diabetes`
- `blood-sugar-after-pancreatitis`
- `pancreatic-cancer-type-3c-diabetes`
- `specialized-vs-general`

**B. Day-to-day management**
- `cgm-for-type-3c-diabetes`  ← bright spot (pos 9.5); give it extra inbound links
- `time-in-range-type-3c`
- `hot-weather-blood-sugar`
- `glp1-type-3c-diabetes`
- `diabulimia`

**C. Choosing an app (conversion)**
- `best-app-type-3c-diabetes`
- `type-3c-diabetes-app`

---

## 3. Internal-link rules (the actual mechanism)

1. **Pillar links down** to all eleven cluster articles (grouped as above), each as a contextual in-body link inside its summary section — not a bare list.
2. **Every cluster article links up** to `/type-3c-diabetes` in two places:
   - one contextual in-body link early on ("part of our [complete guide to Type 3c diabetes]"),
   - a breadcrumb at the top: `Home › Type 3c diabetes guide › <article>`.
3. **Siblings link across** to 3-4 articles in the *same* sub-cluster via the existing "Related reading" block (most already do; just make sure they favour same-cluster siblings).
4. **Homepage (`index.html`) adds a prominent link** to the pillar as the canonical Type 3c entry point.
5. **`blog.html`** (current index of 10) keeps its list but adds the pillar at the top as "Start here."
6. Give `cgm-for-type-3c-diabetes` a couple of extra inbound links (from the pillar's management section and from `time-in-range-type-3c`) — it's closest to breaking onto page 1, so concentrate authority there.

Keep clean URLs throughout (`/slug`, no `.html`), matching the existing `href="/cgm-for-type-3c-diabetes"` pattern.

---

## 4. Guardrails (from repo CLAUDE.md / STANDARDS.md)

- YMYL health content: hand-written, every claim sourced, demonstrate lived experience + expertise. NO programmatic/templated/spun pages.
- **Draft only — a human reviews before publish. NEVER auto-publish.** Ship the pillar as a draft/`noindex` until reviewed, then flip.
- UK English. No em dashes. No Twitter/X meta tags. Organization schema (publisher LW Data Labs LTD). Footer → lwdatalabs.co.uk. Only sanctioned cross-link is GlycoTrace ↔ GlucoEnzyme.

---

## 5. Execution order

1. Draft the pillar page (section skeleton above), `noindex` until reviewed.
2. Add the up-links + breadcrumbs to all eleven cluster articles.
3. Tidy each "Related reading" block to favour same-cluster siblings; add the extra links into `cgm-for-type-3c-diabetes`.
4. Add pillar links on `index.html` and `blog.html`.
5. Human review → remove `noindex` → publish.
6. Update `sitemap.xml` with the new pillar URL.
7. Run the post-publish indexing checklist: in GSC, Request Indexing for `/type-3c-diabetes` and resubmit `sitemap.xml` (Cloudflare does not ping Google). See the glycotrace-post-publish-indexing memory.
8. Check back in GSC ~3-4 weeks later; watch `type 3c diabetes` position and `cgm-for-type-3c-diabetes` movement. Do not tinker before then.
