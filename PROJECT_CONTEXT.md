# Project Handover Context: GlycoTrace v2.0 (Master Sync)

## 📌 Overview
**GlycoTrace** is a Flutter-based metabolic analysis platform. It has transitioned from reactive monitoring to **Retrospective Auditing**, allowing users to reconcile live sensor data (LibreLinkUp) against backfilled CSV truth-data for better metabolic clarity.

## 🛠 Tech Stack
- **Frontend:** Flutter (v3.10+) - Multi-platform (Android prioritized).
- **Backend:** Supabase (Auth, PostgreSQL, Edge Functions).
- **AI/ML:** 
    - **Glucoflow AI 2.0:** Groq (Llama 3.3 70B) for momentum-aware analysis.
    - **OCR:** Google ML Kit (On-device for Garmin reports).
- **Security:** Biometric Auth + Supabase RLS.

## 🧠 Master Logic & Paradigm
1. **Retrospective Auditing:** The core philosophy shift. Identifying patterns and "Near Misses" by comparing live sensor streams against post-hoc CSV ground truth.
2. **Momentum Analysis ($G_{v}$):** Incorporating Glucose Velocity into analysis to factor in downward/upward trends.
3. **The Phantom Auditor:** A synchronization layer that identifies discrepancies between asynchronous LLU data and manual logs.
4. **Safety-Aware Fasting:** Automatic "Safety Pivot" that pauses fasting timers and prioritizes metabolic stability if glucose drops below 4.0 mmol/L.
5. **Separation of Averages:** Critical UI requirement to split **Basal** and **Bolus** averages for clear insulin sensitivity insights.
6. **Visual Standards:** Minimalist, high-contrast mmol/L graphs with color-coded thresholds (Red <3.9, Green 3.9-10, Amber 10.1-13, Dark Red >13).

## ✅ Completed in this Session
1. **Branding:** Renamed project from "Glucose Tracker" to **GlycoTrace** across all platforms. Generated production icons.
2. **Package Identity:** Updated ID to `com.glucosefreaks.tracker`.
3. **Comprehensive Onboarding:** 
   - Implemented a reusable **AppTutorial** system.
   - Added contextual guides for **Dashboard** (Sync & Manual), **Quick Log** (Search & Basket), **Insights** (Patterns & Confidence), and **Settings** (Biometrics & Units).
4. **Global Units:** Added dynamic unit switching support for **Glucose** (mmol/L/mg/dL) and **Height** (cm/ft). Created `UnitUtils` for centralized conversion.
5. **Code Organization:** Moved all UI files into `lib/screens/` and cleaned up redundant root files.
5. **Monetization Ready:** Added `AdService` (AdMob stub) and `PremiumService` (Subscription tier logic with expiration checks).
6. **Glucoflow AI Integration:** 
   - Deployed Supabase Edge Function `ai-chat` using Groq's Llama 3.1 model.
   - Implemented `AiChatScreen` with a contextual data pipeline (48h history + 30-day patterns).
   - Fixed **Temporal Alignment** by injecting explicit Current Date/Time headers to prevent hallucination.
7. **Metabolic & Goal Insights:** 
   - Enhanced `DatabaseService` with success-based pattern recognition.
   - Added **Macro Guardrails** to compare 7/30-day averages against user-set goals.
   - Implemented **Contextual Success** notifications for stable glucose windows.
   - Added **Lite Mode (Diary Only)** for non-medical users.
8. **Performance & Accuracy:**
   - **Parallel Search:** Optimized food database/API retrieval to reduce latency.
   - **Nutrition Normalization:** Fixed Open Food Facts mapping to prioritize 100g data and ensured consistency across history logs.
9. **Metabolic Standards & Safety:**
   - Updated `STANDARDS.md` with refined Pharmacokinetics and Retrospective Calculation philosophy.
   - Implemented **Insulin Stacking Warning** in Quick Log (3-hour window check).
   - Added **Bolus Gap Tracking** (Insulin vs. Carb timing) and a composite **Bolus Accuracy** score.
10. **Intermittent Fasting:**
   - Integrated a complete **Intermittent Fasting Module** with automated timer reset logic.
   - Added dashboard visualizations for physiological stages (Fed, Post-Absorptive, Fat-Burning).
   - Implemented **Strict vs. Dirty Fasting** toggles in settings.
11. **Compliance & Security:** 
   - Added **Account & Data Deletion** (Mandatory for Play Store).
   - Generated `privacy_policy.html`.
   - Updated UI headers to reflect "Retrospective Analysis."
   - Generated `supabase_gdpr_setup.sql` for Row Level Security (RLS).
12. **App Signing:** Generated `upload-keystore.jks` and configured `build.gradle.kts` for automated release signing.
13. **Biometric Security:**
    - Implemented `BiometricService` and a mandatory `BiometricGate` for data protection.
    - Added Fingerprint/FaceID toggles in Settings with instant verification logic.
14. **Search Intelligence:** 
    - Added automated performance logging for low-result search queries to bridge database gaps.
15. **Timeline & Fasting Refinements:**
    - Added multi-select aggregation for **Protein** alongside carbs and calories in the History screen.
    - Hardened fasting logic with resilient fallback for low-calorie meal logs.
16. **Web Infrastructure:**
    - Migrated landing page to a dedicated repository (`glycotrace-web`) for clean separation.
    - Integrated **Google Analytics** (G-R2E0YZX9L4) and switched to professional **Lucide SVG icons**.
    - Refined mission statement to focus on personal story and functional clarity.
17. **Support Pivot:** Transitioned the "Hire Me" page to a **Technical Support & Projects** model, focusing on practical data and operations support.
18. **Firebase Test Lab Optimization (Feb 24, 2026):**
    - Updated 40 test cases in `firebase_test_cases.yaml` with explicit navigation goals (e.g., "Navigate to History tab").
    - Refined `robo_script.json` to guide the AI crawler through all major tabs post-login for 100% feature coverage.
19. **AI Strategy Shift (Feb 24, 2026):**
    - Evaluated **Firebase Vertex AI (Gemini)** migration for improved security (App Check) and remote prompt management.
    - Decision: Maintain current Supabase Edge Function setup for closed beta, then migrate for public launch.
20. **Identified Stability Issues (Feb 24, 2026):**
    - Regression in **Graph Zoom** functionality on the `cause_effect_chart_screen.dart`.
    - **Data Persistence:** Intermittent loss of Weight/Height profile and Fasting state (suspected SQL/DB issue).
    - **Settings:** "Reset Averages" (Fresh Start) logic failing to zero out daily metrics.
## 📂 Current Architecture
- `lib/screens/`: Contains all UI screens (Dashboard, Quick Log, Exercise, Insights, etc.).
- `lib/database_service.dart`: Main gateway for Supabase operations and metabolic calculations.
- `lib/ai_reader_service.dart`: Handles OCR logic for scanning Garmin screenshots.
- `lib/premium_service.dart`: Manages the logic for locking/unlocking features based on tier.

## 🚀 Next Steps / Roadmap
1. **Critical Bug Fixes:** Restore Graph zoom, fix decimal rounding/readability, and debug data persistence (Weight/Height/Fasting).
2. **Settings Logic:** Fix "Fresh Start" averages reset.
3. **Internal Testing:** Deploy to Play Store "Internal Testing" track for GlycoTrace Ltd (Corporate account status simplifies the 20-tester rule).
4. **AI Migration Plan:** Draft Vertex AI transition roadmap for public launch.

## 💡 Conversation Prompts for Gemini
- "How do I set up GitHub Pages to host my privacy_policy.html for free?"
- "Help me design a set of 4 screenshots for a metabolic analysis app listing."
- "What is the best way to handle 'Closed Testing' for 20 people in the Google Play Console?"
- "How do I integrate RevenueCat into this Flutter app to handle actual payments for the Premium tier?"
