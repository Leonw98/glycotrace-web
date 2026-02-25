# GlycoTrace Metabolic Standards & Calculation Methodology

## ⚖️ Legal Disclaimer & Transparency
GlycoTrace is a **retrospective metabolic analysis tool**. It is NOT a medical device and does NOT provide real-time medical advice or dosing recommendations. All calculations are based on user-provided data and are intended for educational pattern discovery only.

---

## 💉 1. Rapid-Acting Insulin Standards
**Baseline:** Based on standard pharmacokinetics for modern rapid-acting analogs (Novorapid, Humalog, Apidra).

### **Standard Timing (Defaults):**
*   **Onset:** 15 minutes.
*   **Peak Activity:** 60–120 minutes.
*   **Duration (Action Time):** 4–5 hours.
*   **Insulin Stacking Warning:** Triggered if a second rapid-acting dose is logged within 3 hours of a previous dose.

---

## 📉 2. Calculation Methodology: "Actual" vs. "Theoretical"
**Philosophy:** The system is **Retrospective**, not predictive. It calculates the **Actual Drop** observed in user data, rather than enforcing a theoretical "perfect" ratio.

*   **Logic:** If 2 units drops glucose to 10.0 mmol/L (instead of a theoretical target of 6.0 mmol/L), the system records the actual ending value for that specific context (e.g., high fat, missed timing). 
*   **Outcome:** These "Real-World" results update the user's **Learned Patterns**, providing a more accurate reflection of their biological response than a static medical formula.

---

## ⏱️ 3. Bolus Timing & Pairing
*   **Pairing Rule:** An insulin dose is paired with a glucose reading for sensitivity analysis if they occur within **15 minutes** of each other.
*   **Bolus Gap:** The system calculates the `Bolus Gap` (Insulin Timestamp - Carb Timestamp).
*   **Efficiency Analysis:** Differentiates efficiency between:
    *   **Pre-Bolus:** High efficiency (Injecting before eating).
    *   **Mealtime/Post-Bolus:** Lower efficiency/Higher spikes (Injecting at or after eating).

---

## 🏃 4. Exercise Intensity & Efficiency
**Baseline:** Differentiation between Aerobic (glucose-lowering) and Anaerobic (potential temporary spike/stable).

### **Thresholds:**
*   **Aerobic Focus:** < 7 kcal/min/kg. Typically results in immediate glucose drop.
*   **Anaerobic Focus:** > 10 kcal/min/kg. May cause temporary glucose rise due to adrenaline/cortisol.
*   **Post-Exercise Sensitivity Boost:** Calculated by comparing Insulin Sensitivity in the **6-hour window** post-exercise vs. non-exercise days.

---

## 📊 5. Glycemic Variability (GV)
**Baseline:** Target Coefficient of Variation (CV) is < 36%.
*   `CV = (Standard Deviation of Glucose / Mean Glucose) * 100`.
*   **High Variability:** > 36% (Indicates higher risk of hypoglycemia and instability).

---

## 🧬 8. Biological Precision (Metabolic Gender Logic)
**Baseline:** Metabolic stability and insulin sensitivity differ between biological sexes due to hormonal influences on glucose metabolism.

### **Gender-Aware Analysis:**
*   **Male:** Typically higher muscle-to-fat ratio; higher basal metabolic rate (BMR). Insulin sensitivity calculations prioritize lean body mass (LBM) as the primary glucose sink.
*   **Female:** Monthly hormonal cycles (Progesterone/Estrogen) significantly impact insulin resistance. Insights prioritize "Stability Trends" over absolute values during high-progesterone phases to account for natural resistance shifts.

---

## 🍕 9. Glucoflow AI: "Gym vs. Pizza" Logic
**Baseline:** AI must distinguish between a glucose spike caused by external intake (Food) and internal release (Liver/Stress).

### **Spike Differentiation Rules:**
*   **The "Pizza" Spike (Exogenous):** 
    *   **Indicators:** High Carb Log within 60 mins AND High Protein/Fat Log.
    *   **Pattern:** Rapid rise, sustained plateau (Fat/Protein delay), and high variability.
    *   **AI Insight:** "Exogenous carb overload. Suggests meal-timing or carb-ratio adjustment."
*   **The "Gym" Spike (Endogenous):**
    *   **Indicators:** Anaerobic Exercise Log within 30 mins AND Zero/Low Carb Log.
    *   **Pattern:** Sharp rise (Adrenaline/Cortisol-induced liver dump) followed by rapid recovery without insulin.
    *   **AI Insight:** "Metabolic Stress Dump. Adrenaline-driven glucose release; likely to resolve without correction."

---

## 🔍 10. Data Integrity Requirements
For calculations to be considered "Reliable" in the Insights tab:
*   **Glucose Data:** Minimum 14 days of sync data.
*   **Completeness:** Minimum 70% sensor wear time (estimated via reading count).

---

## 🍽️ 7. Intermittent Fasting (IF) by Classification
**Baseline:** The "Metabolic Switch" (Lipolysis) occurs when liver glycogen is depleted and insulin is low.

### **Classification-Specific Logic:**
*   **Type 1 / Type 3c:** 
    *   **Focus:** Safety & Insulin Clearance.
    *   **Threshold:** Lipolysis is inhibited while rapid-acting insulin is active (4-hour window).
    *   **Risk:** High hypoglycemia risk; fasts must be paused for any reading < 4.0 mmol/L.
*   **Type 2:** 
    *   **Focus:** Insulin Sensitivity.
    *   **Metabolic Switch:** Typically occurs 6–12 hours post-prandial depending on insulin resistance levels.
    *   **Benefit:** IF is a recognized tool for reducing resistance and aiding remission (NICE/ADA).
*   **Pre-Diabetic:**
    *   **Focus:** Resistance Reversal & Pancreatic Recovery.
    *   **Metabolic Switch:** Typically 10–14 hours post-prandial.
    *   **Goal:** Re-establishing metabolic flexibility through stabilized glucose windows (< 7.0 mmol/L).
*   **Non-Diabetic (Wellness):**
    *   **Focus:** Autophagy & Fat Oxidation.
    *   **Metabolic Switch:** 12–16 hours post-prandial (Glycogen depletion baseline).

