# Handover — Freelance / Hire Me Page Assets

> **Page:** https://glycotrace.co.uk/freelance.html
> **Local file:** `D:\src\glycotrace-web\freelance.html`
> **Purpose:** Inventory of every freelance / portfolio asset Leon has produced across `D:\src\Freelance\` that could be lifted onto the Hire Me page. Lets the next agent pick assets without re-discovering what exists.
> **Last update:** 2026-04-28

---

## 1. Current state of `freelance.html`

Already on the page (working baseline):
- Hero with "Hire me on Upwork" + email + LinkedIn buttons.
- Three service cards: **Data & Ops Architecture**, **Process Automation**, **Pragmatic UX & UI**.
- "What I've actually shipped" section — stats (23 tables, 21 FKs, 3 device integrations), Mermaid backend diagram, three GlycoTrace screenshots (`Assets/Dash.png`, `Assets/Insights.png`, `Assets/Timeline.png`).
- "Finish what you started" approach panel + Project Impact bullets (RBL, scrapers, GlycoTrace).
- CTA + footer.

**What's missing (and what the assets below are for):**
- No client-work case studies. Page says "10k+ entities scraped" but shows no proof artefact.
- No diagrams of the *delivery process* (how Leon turns a brief into a clean dataset).
- No before/after CRM cleaning sample — even though one exists.
- No PDF deliverable preview.
- No third-sector / charity case study, even though the Acorns pack is the strongest single piece of work he's produced this quarter.

---

## 2. The asset library — `D:\src\Freelance\03_Shared_Assets\`

These are already designed as reusable portfolio pieces. They have HTML + JPG + PDF triplets so they can be embedded as preview images that link to the PDF.

| Asset | Files | What it shows | Suggested placement |
|---|---|---|---|
| **CRM Cleaning Before/After** | `CRM_Cleaning_Before_After.html` / `.jpg` | Visual before/after of a messy CRM table cleaned and verified | New "Data quality" card under "Process Automation" |
| **Custom Scraper Audit** | `Custom_Scraper_Audit.html` / `.jpg` / `.pdf` | Audit-style report on a scraping engagement | "Proof of Work" — second case study tile |
| **Forensic Embroidery Sample (ARCO)** | `Forensic_Embroidery_Sample_ARCO.html` / `.jpg` / `.pdf` | One real lead row, fully enriched, with verification trail | First case study tile (best single artefact) |
| **Forensic Lead Export — UK Embroidery & Workwear** | `Forensic Lead Export — UK Embroidery & Workwear.pdf` | Full lead pack PDF (from YES Group job) | Linkable PDF from the Embroidery tile |
| **Forensic Pipeline Flowchart** | `Forensic_Pipeline_Flowchart.html` / `.jpg` | Diagram of the find → contact → verify → enrich pipeline | Replace or sit beside the GlycoTrace Mermaid diagram in a new "How I deliver" section |
| **Forensic Spreadsheet Sample** | `Forensic_Spreadsheet_Sample.html` / `.jpg` / `.pdf` | Spreadsheet preview (column structure, sample rows) | "What you actually receive" tile |
| **PSC Intelligence Map** | `PSC_Intelligence_Map.html` / `.jpg` / `.pdf` | Map of Persons of Significant Control across companies | "Research depth" tile (Companies House work) |

**Conventions in this folder:**
- Every `.html` is a self-contained styled preview (no external CSS dependency on the website).
- Every `.jpg` is a hero/preview image of the same artefact — use these as the `<img>` source on the hire page.
- Every `.pdf` is the printable deliverable — link these from the `<figure>` so a hiring manager can download.

---

## 3. The Acorns pack — `D:\src\Freelance\01_Jobs\2026-04-17_AcornsHospice\`

Built for the Acorns Children's Hospice interview (30 April 2026). Even if Leon takes the role, this is **portfolio gold** and should be referenced on the hire page once the interview is over.

| File | What it is |
|---|---|
| `UPWORK_CASE_STUDY.html` | Already-styled case study page — drop-in candidate for the hire page. |
| `DIAGRAMS_PACK.html` / `REAL_SYSTEMS_DIAGRAMS.html` | Mermaid / system diagrams for a Donorfy-shaped CRM and the diagnostic flow. |
| `Acorns_Peer_Benchmark.xlsx` | Real Excel deliverable — peer benchmark of UK children's hospices from Charity Commission filings. |
| `acorns_benchmark_report.pbip` + `acorns_benchmark_report.Report` | Power BI Project file — proof of Power BI / DAX / RLS competency. Screenshot the report pages and use those as image assets. |
| `Donorfy_Diagnostic_Sample.xlsx` | Diagnostic sample showing data quality issues a typical hospice CRM would have. |
| `CV.html` / `COVER_LETTER.html` | Already-styled CV and cover letter — design language is consistent with the hire page. Useful as a "Download CV" link. |

**Sensitivity check before publishing:** the Acorns folder contains the live application. Don't link any file that names Acorns by name without scrubbing first. The benchmark methodology, the Donorfy diagnostic, the diagram pack, and a *re-titled* Power BI screenshot are all fine to publish; the cover letter and Acorns-specific CV are not.

---

## 4. Other job folders worth mining

| Folder | What's in it that could become a portfolio piece |
|---|---|
| `01_Jobs/2026-03-01_Ed_Hill_Forensic_Intel/` | `3_Final_Outputs/` — large-entity scraping deliverables. `PROCESS_REVIEW.md` is a written postmortem. |
| `01_Jobs/2026-03-27_YES_Group_Embroidery/` | The Forensic Embroidery sample in `03_Shared_Assets` came from this job — the rest of the output folder has more depth. |
| `01_Jobs/2026-04-08_Lead_Gen_500/` | Lead-gen at scale — a "500 leads in N hours" stat could anchor a new card. |
| `01_Jobs/2026-04-14_Coffee_Roasters_UK/` | Sector-specific lead pack — visual variety. |
| `04_Archive/Portfolio_Showcase/` | Already-curated showcase folder (worth opening). |
| `04_Archive/Portfolio_Repos/` | Repo-style portfolio (worth opening). |

---

## 5. Internal tools that prove "I ship" (not just consult)

These are not assets to embed — they're *narratives* to add to the page.

- **Mini Apollo** (`D:\src\MiniApollo\`) — primary internal lead-gen app, port 8080, find → contact → email pipeline, 83 tests. Frame as: "internal tool · supports paid client work" so it doesn't read as a public product.
- **GlycoTrace v2.0** — already on the page via the Mermaid diagram + screenshots. The "23 tables / 21 FKs / 3 device integrations" stats are correct.
- **OpenClaw + LM Studio scraping stack** (`D:\src\Freelance\99_Documentation\OPENCLAW_HANDOVER.md`) — local-LLM scraping rig, no cloud token cost. Could become a "How I keep client costs down" card.
- **Triage system** (`10_Upwork/triage.py`) — every Upwork JD goes through a structured triage before bidding. Demonstrates rigour.

---

## 6. Concrete additions the page is asking for

In priority order — pick from these when the user asks "what should we add next":

1. **A "Recent Work" section** with 3 case study tiles, each using a `03_Shared_Assets` JPG as the preview image and linking to the matching PDF. Suggested first three:
   - Forensic Embroidery Sample (ARCO) — single real enriched lead.
   - Custom Scraper Audit — written audit deliverable.
   - PSC Intelligence Map — Companies House depth.
2. **A "How I deliver" section** with the Forensic Pipeline Flowchart as the hero image (replaces or sits beside the GlycoTrace Mermaid diagram).
3. **A "What you receive" tile** using `Forensic_Spreadsheet_Sample.jpg` — answers the unspoken question "what does the deliverable actually look like?".
4. **A charity / third-sector case study** using a sanitised version of the Acorns benchmark + Donorfy diagnostic. This widens the page beyond "Upwork lead-gen guy" into "data and insight at organisational scale".
5. **A downloadable CV** — `CV.html` from the Acorns folder is already styled in a compatible visual language; lift it as `cv.html` at the site root and link from the hero buttons.

---

## 7. Style + tech notes for whoever picks this up

- Page uses **vanilla CSS** from `style.css`. Reuse `.glass-card`, `.feature-grid-fancy`, `.btn-primary-fancy`, `.btn-glass`, `.section-tag`, `.gradient-text`, `.cta-glass-card`, `figure` patterns already in `freelance.html`.
- Icons via **Lucide** (already loaded). Add new ones with `<i data-lucide="icon-name">`.
- Diagrams via **Mermaid 10** (already loaded). Theme variables already configured at the bottom of the page — match the dark palette.
- Images live in `D:\src\glycotrace-web\Assets\`. Copy in any new asset there before referencing it (don't hotlink from `D:\src\Freelance\`).
- Schema.org JSON-LD at the top of the page lists the three services. **If you add a fourth service card, also add it to the `OfferCatalog` block.**
- Footer link list is duplicated across pages — don't update one without checking `index.html`, `science.html`, `news.html`, `resources.html`, `tutorials.html`, `calculators.html`, `apply.html`.
- Canonical link is set — leave it alone.

---

## 8. What NOT to do

- Don't add hourly rates back. The page deliberately moved away from them on 26 Feb 2026 (see `PROGRESS.md`).
- Don't use the word "consulting" in the new sections — the page tone is "builder who finishes things", not "consultant".
- Don't publish anything from the Acorns folder that names Acorns by name until the interview outcome is known.
- Don't break the Mermaid diagram — it's a centrepiece. If you replace it, make sure the new image is at least as detailed.
- Don't introduce a new font, new colour, or new framework. The visual language is locked.
