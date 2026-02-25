# GlycoTrace Project Progress

## 🚀 Daily Log: 24 Feb 2026 (Hardening & Beta Preparation)

### **1. Firebase Test Lab Optimization**
*   **Explicit Navigation:** Updated all 40 test cases in `firebase_test_cases.yaml` to include explicit navigation goals (e.g., "Navigate to History tab"), preventing AI robots from getting lost.
*   **Robo Script GPS:** Refined `robo_script.json` to force a full-app traversal (History -> Insights -> Exercise -> Quick Log) immediately after login to ensure 100% feature coverage during automated crawls.
*   **Device Stability:** Targeted improvements for Motorola and Medium Phone profiles to reduce timeout failures.

### **2. AI Strategy & Infrastructure**
*   **Vertex AI Evaluation:** Researched migration from Supabase Edge Functions to **Firebase Vertex AI (Gemini 1.5 Flash/Pro)**.
*   **Strategic Decision:** Retaining Supabase for closed beta for speed, but planned migration for public launch to leverage **Firebase App Check** (security) and **Remote Config** (instant prompt updates without app release).

### **3. Identified Issues & Bug Backlog**
*   **UI/UX Regressions:**
    *   **Graph Zoom:** Lost zoom functionality in `cause_effect_chart_screen.dart`.
    *   **Data Readability:** Overlay decimals need rounding to 1 place; dark blue overlay is currently low-contrast/hard to read.
*   **Logic & Persistence Bugs:**
    *   **Fresh Start:** "Reset Averages" functionality in Settings is not correctly clearing daily metrics.
    *   **Vanishing Data:** Fasting state and Profile data (Weight/Height) are intermittently disappearing, suggesting a potential SQL synchronization or local persistence issue.
*   **Feedback System:** Identified a PostgreSQL issue in the feedback submission flow; plan to add device metadata (OS version, etc.) to logs.

---

## 📌 Next Steps
*   [ ] Fix Graph Zoom and Overlay readability.
*   [ ] Debug Weight/Height and Fasting data persistence (SQL check).
*   [ ] Verify "Fresh Start" averages reset logic.
*   [ ] Upload founder's photo and verify Zoho DNS (Carried over).
*   [ ] Prepare Play Store "Internal Testing" track for GlycoTrace Ltd (Tester requirement bypassed due to corporate account status).
