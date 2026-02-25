# GlycoTrace v2.0

A high-performance personal metabolic analysis platform built with Flutter and Supabase. Developed by **GlycoTrace Ltd**, this tool provides retrospective analysis for FreeStyle Libre users, with specialized support for Type 1, Type 3c, and Pre-Diabetic profiles.

## 🌟 Key Features
*   **The Daily Pulse:** Automated background sync via LibreLinkUp with multi-region network resilience.
*   **Biometric Security:** Industry-standard Fingerprint and FaceID protection via a secure Biometric Gate.
*   **Glucoflow AI 2.0:** Context-aware metabolic analyst (Llama 3.3) that distinguishes between dietary spikes and exercise-induced "stress fuel" dumps.
*   **Biological Precision:** Gender-aware metabolic analysis that accounts for biological differences in insulin sensitivity and stability.
*   **Fasting Intelligence:** Personalized "Fat Burning Forecasts" with resilient fallback logic for low-calorie logs.
*   **Cause & Effect Timeline:** Unified chronological view of food, exercise, and doses with multi-select protein and carb aggregation.
*   **Clinical Data Standards:** Integrated 14-day data quality monitoring and clinical-grade reporting.

## 🛠️ Tech Stack
*   **Frontend:** Flutter (v3.10+) - Multi-platform (Android prioritized).
*   **Backend:** Supabase (Auth, PostgreSQL, Edge Functions).
*   **AI/ML:** 
    *   **Cloud:** Groq (Llama 3.3 70B) for Glucoflow AI.
    *   **On-Device:** Google ML Kit for Garmin OCR reports.
*   **Security:** Biometric Auth + Supabase RLS (Row Level Security).
*   **Hosting:** GitHub Pages (`https://glycotrace.co.uk`) and Supabase Edge Functions.

## 🏗️ Project Structure
*   **Private App Repository:** Contains the core Flutter engine and proprietary sync logic.
*   **Public Web Repository:** Hosts the landing page and community portal.
*   **Development History:** Detailed daily logs and architectural decisions can be found in [PROGRESS.md](./PROGRESS.md) and [PROJECT_CONTEXT.md](./PROJECT_CONTEXT.md).

## 🛡️ License & Legal
Copyright (c) 2026 **GlycoTrace Ltd**. All rights reserved.
Company No. 17048417 (England & Wales).
Proprietary software. Unauthorized use or distribution is strictly prohibited.

*Disclaimer: GlycoTrace is a retrospective analysis tool and is not a medical device. Always consult with a healthcare professional.*
