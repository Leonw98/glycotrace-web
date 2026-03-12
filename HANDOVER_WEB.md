# GlycoTrace Web Update - Handover Document (Feb 25, 2026)

## 📋 Project Status
**Current Version:** v2.0 (Internal Beta Ready)
**Target Hardware:** Pixel 9 (Validated)
**Primary Focus:** Clinical safety, RevenueCat monetization, and automated cloud backfill.

---

## 🏢 Company Context
- **Name:** GlycoTrace Ltd
- **Company No:** 17048417 (England & Wales)
- **Support Email:** team@glycotrace.co.uk
- **Domain:** glycotrace.co.uk

---

## 🛠️ Tech Stack for Web Updates
- **Frontend Framework:** Vanilla CSS (preferred) / React / Tailwind (if requested).
- **Icons:** Lucide SVG (Standardized).
- **Backend:** Supabase (Auth/Database/Functions).
- **Analytics:** Google Analytics (ID: G-R2E0YZX9L4).
- **Assets:** `assets/images/app_logo.png`, `assets/images/google_logo.png`.

---

## 🔒 Safety & Regulatory (Must be mirrored on website)
- **Retrospective Disclaimer:** "GlycoTrace is a retrospective analysis tool only. It does not provide real-time medical advice or dosing recommendations."
- **AI Safety Guardrail:** Clinical Safety prohibits AI from real-time dosing advice.
- **Stop Word:** "⚠️ HYPOGLYCEMIA ALERT" (System-wide stop for glucose < 4.0 mmol/L).

---

## 📊 Feature Specifications for Marketing
1.  **RevenueCat Funnel:** Production-grade monetization flow with a 3-day full-access grace period for new users.
2.  **Cloud-to-Local Backfill:** Instant recovery of targets and profile (Weight/Height) via Supabase on fresh installs.
3.  **LibreLinkUp Auto-Sync:** Automated background fetching with multi-region fallback (EU, US, AE, etc.).
4.  **Glycoflow AI 2.0:** Uses Groq (Llama 3.3 70B) for pattern discovery based on 48h history and 14-day trends.
5.  **Clinical Standards:** %CV (Glycemic Variability) calculated on a strict 14-day window for stability.
6.  **Smart Fasting Engine:** Differentiates between minor snacks and meals to maintain accurate fasting tracking, displaying aggregated intake (e.g., "Chicken, Broccoli").
7.  **Garmin OCR Import:** Robust, computer-vision powered import for Garmin Connect activity screenshots directly into the app.

---

## 📂 Key File Locations for Web Context
- **Privacy Policy:** `privacy_policy.html`
- **Release Notes:** `release_notes.txt`
- **Technical Standards:** `STANDARDS.md`
- **Project Context:** `PROJECT_CONTEXT.md`

---

## 🚀 Recent Accomplishments (v2.0 Beta Hardening)
- Fixed project-wide import regressions (`glucose_tracker_v2_0`).
- Hardened CSV import logic with Abbott Libre fingerprinting and injection prevention.
- Validated "LOW DETECTED" and "HIGH DETECTED" dashboard banners on Pixel 9.
- Sequentialized Open Food Facts API calls to ensure zero 429 rate-limiting failures.
- Implemented **Meal Aggregation Logic** to group food logged within 30-45 minutes into unified meals for AI context.
- Perfected **Garmin OCR Parsing** to correctly handle split stats and duration formats.
- Resolved Biometric Gate race conditions on Android with a stable 250ms delay mechanism.

---

## 💡 Webchat Search Prompts
- "Update the landing page landing.html to include the new 'Cloud Backfill' feature."
- "Create a new 'Pricing' section reflecting the 3-day grace period for RevenueCat subscriptions."
- "Integrate the Lucide SVG icons for 'Metabolic Stability' and 'AI Insights'."
