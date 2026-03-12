# GlycoTrace — Claude Handover
**Date:** 08 Mar 2026
**Build:** v1.1.0+16
**Branch:** master

---

## 🗺️ What This Project Is

Flutter glucose tracker / metabolic analysis app for FreeStyle Libre users. Personal-use tool that Leon has been testing on himself for ~1 month. Approaching LinkedIn showcase / informal pilot phase.

- **Not a medical device** — retrospective analysis only, never real-time dosing advice
- Company: GlycoTrace Ltd (Co. No. 17048417, England & Wales)
- Target device: Google Pixel 9 (Android)
- Supabase project ref: `wklflsykzbepcilorvjd`

---

## 🏗️ Architecture at a Glance

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart), Android/Pixel 9 |
| Auth + DB | Supabase (PostgreSQL + RLS + Edge Functions) |
| AI | Groq Llama 3.3 70B via Supabase Edge Function `ai-chat` |
| Food reservoir | MotherDuck (DuckDB) `master_food_staples` |
| OCR | Google ML Kit (on-device, Latin script) |
| Notifications | flutter_local_notifications + timezone |
| Local cache | sqflite + shared_preferences |
| Crash reporting | Firebase Crashlytics |
| Secrets | `--dart-define` at build time — never bundled |

**Build command:**
```
flutter run -d <device-id> \
  --dart-define=SUPABASE_URL=https://wklflsykzbepcilorvjd.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<key>
```
Keys are in `.env` (not committed). Do not add `.env` to git.

**Edge Function deploy:**
```
npx supabase functions deploy ai-chat --project-ref wklflsykzbepcilorvjd --no-verify-jwt
```
`--no-verify-jwt` is intentional — function handles auth itself via `getUser()`.

---

## 📂 Key Files

| File | Purpose |
|---|---|
| `lib/main.dart` | App entry, BiometricGate, auth stream |
| `lib/screens/dashboard.dart` | Main dashboard — complex custom AppBar, **do not restructure the header** |
| `lib/database_service.dart` | All Supabase queries, metabolic calculations |
| `lib/notification_service.dart` | All local notifications, fasting milestones, safety alerts |
| `lib/ai_chat_service.dart` | Groq via Edge Function, retry-on-401 logic |
| `lib/ai_reader_service.dart` | OCR parsers (Garmin, News Feed, glucose, universal activity) |
| `lib/screens/exercise_screen.dart` | Exercise logging + OCR scan entry point |
| `lib/screens/quick_log_screen.dart` | Food/insulin logging, basket, AI food entry |
| `lib/biometric_service.dart` | local_auth v3 wrapper |
| `lib/premium_service.dart` | RevenueCat + pilot unlock flag |
| `supabase/functions/ai-chat/index.ts` | Edge Function — Groq call, supports `raw`/`model`/`temperature` params |

---

## ✅ What Was Done This Session (08 Mar 2026)

### 1. Fasting-Aware Notifications
**Problem:** Notifications had no fasting context awareness.

**Changes:**
- `database_service.dart` — `logFood()` now skips both `schedulePostMealAnalysis` and `scheduleInactivityReminder` if meal timestamp is >4 hours old (backdated log fix)
- `notification_service.dart` — `schedulePostMealAnalysis()` has early-return guard for meals >4h old
- `notification_service.dart` — `scheduleFastingMilestones()` overhauled:
  - Removed 3h milestone (fires during sleep for overnight fasters)
  - 6h: hydration + "check monitor now" (Importance.high)
  - 12h: hydration + elevated urgency, "watch for downward trend"
  - 16h: hydration critical + "check sensor now"
- `notification_service.dart` — New `showFastingTrendingDownAlert(double glucose, double velocity)`:
  - 3-tier severity: advisory (Gv < -1.5) / act soon (glucose < 4.5) / critical (glucose < 3.9)
  - Notification ID 805, channel `fasting_safety`
- `dashboard.dart` — New `_checkFastingTrend(double glucose, SharedPreferences prefs)`:
  - Called from `_fetchGlucose()` when fasting is active
  - Uses existing `calculateGlucoseVelocity()` (30-min window)
  - Rate-limited to once per 30 min via `last_fasting_trend_alert` pref

### 2. Garmin News Feed OCR Import
**Problem:** Existing OCR parsers targeted table/report views. The Garmin Connect web "News Feed" uses a card layout with relative timestamps ("5h ago", "6h ago").

**Changes:**
- `ai_reader_service.dart` — New private `_parseGarminNewsFeed(RecognizedText, String imagePath)`:
  - Extracts capture time from Android filename `Screenshot_YYYYMMDD-HHmmss`
  - Resolves relative timestamps against capture time
  - Parses activity name, duration (H:MM:SS / H:MM / MM:SS), calories
  - Calorie detection: finds number in values row above a "Calories" label row
- `ai_reader_service.dart` — `pickAndReadActivityScreenshot()` now detects "news feed" or "garmin"+"leaderboard" in OCR text and routes to News Feed parser first

### 3. BiometricGate Ghost Screen Fix
**Problem:** On app launch, `addPostFrameCallback` fires before Android transitions lifecycle to `AppLifecycleState.resumed`. The guard inside `_checkLock` was silently bailing, leaving the lock screen stranded with no biometric prompt.

**Changes:**
- `main.dart` — `_checkLock({bool isInitial = false})` — initial call (from `addPostFrameCallback`) skips the lifecycle state check. Background-resume calls keep it.
- `main.dart` — Added `AUTH_STREAM` debug logging to `StreamBuilder` and `BIOMETRIC_GATE` logging to `_checkLock`
- `main.dart` — Exposed `BiometricGate.hasUnlockedThisSession` static getter for logging

---

## 🐛 Known Issues / Outstanding Work

### High Priority
| Issue | Location | Notes |
|---|---|---|
| **T&Cs scroll-accept screen** | New screen needed | Required before any public/forum testing |
| **CSV import hardening** | `lib/csv_import_service.dart` | Column name variations by region/version, timezone handling, scan vs historic readings |
| **LibreLinkUp ToS risk** | `lib/libre_link_up_service.dart` | Abbott technically prohibits third-party API use. CSV must be solid fallback before forum testing |

### Medium Priority
| Issue | Location | Notes |
|---|---|---|
| **Notification RangeError** | `notification_service.dart` | `RangeError (end): Invalid value: Not in inclusive range 0..24: 25` — hour arithmetic overflow. Not yet investigated |
| **Dashboard setState thrashing** | `dashboard.dart` | `_fetchGlucose`, `_loadGoals`, `_fetchWeight`, `_fetchDailyTotals` still call setState mid-flight. Partial fix done |
| **Sunday metabolic report UI** | New screen | `getGrazeSessionReport` exists in DatabaseService, no UI yet |
| **Recovery Log UI** | Quick Log or Settings | `logRecoveryDay` exists in DatabaseService, no UI yet |

### Low Priority / Icebox
- Personalized insulin decay model (backtesting Gv)
- Logging confidence score (80/90/100%)
- User food overrides ("My Staples")
- GlycoAgent conversational interface
- Full OFF dataset ingestion (milestone: £500/mo revenue)

---

## 🔐 Security Notes

- GROQ_API_KEY lives only as a Supabase secret — not in APK
- LibreLinkUp credentials stored as bearer token in `user_integrations` table (not plaintext)
- `kDebugMode` guards on all PII in logcat
- Biometric: `persistAcrossBackgrounding: true` on `authenticate()`
- `_pilotUnlockPremium = true` in `main.dart` — **remove before Play Store public launch**
- `.env` contains live keys — never commit

---

## 📊 Current Data (Live from LibreLinkUp, 08 Mar 2026)
Leon's glucose: syncing every app open, 15-min intervals, 44-46 readings per sync. Morning readings showed elevated range (15+ mmol/L) trending down through the morning session.

---

## 🚀 Next Session Priorities

1. **CSV import hardening** — column detection, timezone fix, scan/history split, import preview
2. **T&Cs scroll-accept screen** — plain English, GDPR-compliant, required before forum testing
3. **Notification RangeError** — investigate hour arithmetic overflow
4. **LinkedIn post** — app is showcase-ready

---

## 💡 Prompts to Get Started

- *"Read HANDOVER_CLAUDE.md and PROGRESS.md, then harden the CSV import in csv_import_service.dart"*
- *"Read HANDOVER_CLAUDE.md then build the T&Cs scroll-accept screen that gates first-time app use"*
- *"Read HANDOVER_CLAUDE.md then investigate the RangeError in notification_service.dart hour arithmetic"*
