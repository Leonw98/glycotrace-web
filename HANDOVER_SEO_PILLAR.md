# GlycoTrace Web — SEO Pillar/Cluster Handover

**Date:** 14 Jul 2026
**Repo:** `glycotrace-web` (marketing site — static HTML, NOT the Flutter app)
**Written from:** the HQ chat (`D:\LW data labs`), after analysing Google Search Console exports.
**Status of the work:** planned, not started. Nothing has been built or published yet.

---

## Start here (paste into a fresh glycotrace-web chat)

> Read `HANDOVER_SEO_PILLAR.md` and `PILLAR_CLUSTER_PLAN.md`, then draft the new pillar page at `/type-3c-diabetes` as a `noindex` draft following the section skeleton. Do not touch the 11 existing articles yet, do not publish, and stop for my review before removing `noindex`.

---

## What this task is (one paragraph)

The site has **11 strong Type 3c diabetes articles sitting as a flat pile** with only ad-hoc cross-links, and **no page built to own the head term** `type 3c diabetes` (GSC shows it stuck at position ~85). The job is a **one-time restructure**: build one authoritative pillar page and re-link the existing articles up to it, so Google reads the site as *the* Type 3c resource. It is deliberately a single restructure with no ongoing labour — this is a background-mode product, not an active bet.

The full spec lives in **`PILLAR_CLUSTER_PLAN.md`** in this repo. That file is the source of truth: pillar URL, H1, the real target queries (pulled verbatim from 3-month GSC), the section skeleton, the cluster map, the internal-link rules, and the execution order. This handover is just the on-ramp — do not re-derive the plan, follow it.

---

## The GSC evidence behind it (so you don't have to re-pull)

- Head term `type 3c diabetes`: **17 impressions, position ~89** — real demand, no page for it.
- A whole family stuck at **positions 70-98**: `what is / symptoms / causes / diagnosis / test / nhs / vs type 1`, plus `pancreatogenic diabetes`, `type 3c diabetes mellitus`, `t3cdm`. These are the pillar's H2s / FAQ (listed verbatim in the plan).
- `science.html` is accidentally absorbing ~100 impressions at pos ~45 as the catch-all for all of the above — the pillar exists to take that demand and rank it properly. Leave `science.html` in place; just check the pillar out-ranks it after publish.
- **Bright spot:** `cgm-for-type-3c-diabetes` is already at **position ~9.5** (bottom of page 1). The plan concentrates extra inbound links on it because it's closest to breaking through — do not dilute this.

---

## Hard guardrails (from this repo's CLAUDE.md / STANDARDS.md — do not skip)

- **YMYL health content.** Hand-written, every clinical claim sourced. No programmatic/templated/spun pages.
- **Draft only. NEVER auto-publish.** Ship the pillar as `noindex` until a human reviews it, then flip. Stop and hand back before removing `noindex`.
- **Patient-not-clinician schema.** Article + Organization publisher = LW Data Labs LTD. NO `MedicalWebPage` / `reviewedBy` (there are no clinician relationships — see the `glycotrace-publish-without-clinician` rule).
- **Style:** UK English. No em dashes. No Twitter/X meta tags. Clean URLs (`/slug`, no `.html`). Footer links to lwdatalabs.co.uk. Only sanctioned cross-link is GlycoTrace ↔ GlucoEnzyme.
- The pillar must be **genuinely useful standing alone**, not a thin table of contents (that trips the thin-content rail).

---

## After publish (don't forget — Cloudflare does not ping Google)

1. Update `sitemap.xml` with the new `/type-3c-diabetes` URL.
2. In GSC: Request Indexing for the pillar URL and resubmit `sitemap.xml` (see the `glycotrace-post-publish-indexing` rule — new pages are NOT auto-discovered).
3. Check back in GSC **~3-4 weeks later**; watch the `type 3c diabetes` position and `cgm-for-type-3c-diabetes` movement. **Do not tinker before then.**

---

## What NOT to do

- Don't rewrite the 11 existing articles — the plan only adds up-links + breadcrumbs to them.
- Don't publish anything without review.
- Don't chase head terms with new thin pages; the whole point is consolidating existing depth.
- Don't touch the Flutter app repo (`glucose_tracker_v2.0`) — different codebase, different handover (`HANDOVER_CLAUDE.md`).
