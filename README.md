# 🏥 Healthcare Data Analytics

An interactive Power BI dashboard and backend SQL analysis built to analyze hospital operations, patient demographics, and financial performance across a multi-hospital healthcare network from **2019–2024**. The project combines Power Query data cleaning, DAX-driven dashboard reporting, and a standalone SQL analysis layer for data validation and ad-hoc querying. Forecasting is planned as the next extension (see [Future Enhancements](#-future-enhancements)).

---

## 📑 Table of Contents

1. [Problem Statement](#-problem-statement)
2. [Objectives](#-objectives--key-business-questions)
3. [Project Overview](#-project-overview)
4. [Repository Contents](#-repository-contents)
5. [Dataset Description](#️-dataset-description)
6. [Data Cleaning (Power Query)](#-data-cleaning-power-query)
7. [Challenges & Solutions](#challenges-solutions)
8. [Dashboard Pages](#-dashboard-pages)
9. [SQL Analysis](#️-sql-analysis)
10. [Key Insights](#-key-insights)
11. [Recommendations Summary](#-recommendations-summary)
12. [Data Model & DAX Measures](#-data-model--dax-measures)
13. [Skills Demonstrated](#️-skills-demonstrated)
14. [Tools & Techniques Used](#️-tools--techniques-used)
15. [How to Use](#-how-to-use)
16. [Future Enhancements](#-future-enhancements)
17. [Data Source & Disclaimer](#-data-source--disclaimer)
18. [Author](#-author)

---

## 🎯 Problem Statement

Hospital networks generate large volumes of patient, billing, and operational data every day, but this data is often scattered across systems and rarely consolidated into a single, decision-ready view. Without a unified reporting layer, hospital administrators struggle to answer basic but critical questions — which hospitals or doctors are over/under-performing, which medical conditions are driving cost and length of stay, and where revenue is actually coming from.

This project addresses that gap by consolidating a ~55,500-record patient dataset into a single Power BI dashboard — backed by an independent SQL analysis layer for data validation — enabling stakeholders to monitor patient trends, financial performance, and operational efficiency in one place, and to make faster, data-backed decisions on staffing, resource planning, and chronic care management.

---

## ❓ Objectives / Key Business Questions

This project was built to answer questions such as:

- How is patient volume trending year over year, and are there seasonal patterns in admissions or revenue?
- Which medical conditions are most common, and which drive the highest cost and longest stays?
- Which hospitals and doctors are the top (and bottom) performers by patient volume, revenue, and average length of stay?
- Where does hospital revenue actually come from — admission type, insurance provider, age group, or medical condition?
- Is the underlying data itself trustworthy — are there duplicates, nulls, or anomalous values (e.g., negative billing) that need to be flagged before any insight is trusted?
- What operational changes (staffing, discharge planning, specialized clinics) could most improve efficiency and patient outcomes?

---

## 📌 Project Overview

This project transforms a raw healthcare dataset (~55,500 patient records) into a decision-ready Power BI report, with a companion SQL script that independently validates the data and re-derives the key metrics. It covers patient trends, revenue drivers, medical conditions, doctor/hospital performance, and operational efficiency, wrapped up with data-driven insights and recommendations for hospital administrators.

---

## 📂 Repository Contents

| File / Folder | Description |
|---|---|
| `Health Care Dataset.xlsx` | Source workbook containing **both** the messy (raw) and cleaned versions of the dataset as separate sheets (~55.5K patient records) |
| `Cleaned_Health Care Dataset.csv` | Standalone CSV export of the cleaned data — the file actually loaded into Power BI and used as the source for `Healthcare_Analysis.sql` |
| `Messy_healthcare_dataset.csv` | Standalone CSV export of the raw, uncleaned data — useful for viewing the pre-cleaning state without opening Excel |
| `Healthcare Analysis.pbix` | Power BI report file (dashboard + data model), built by loading `Cleaned_Health Care Dataset.csv` |
| `Healthcare_Analysis.sql` | Standalone T-SQL script: data validation/quality checks, demographic and financial analysis, and advanced window-function queries against `health_care_data` |
| `Dashboard Screenshot/` | Preview images of each report page |
| `README.md` | Project documentation (this file) |

---

## 🗃️ Dataset Description

The dataset contains patient-level records with the following fields:

| Column | Description |
|---|---|
| Name | Patient name |
| Age | Patient age |
| Gender | Male / Female |
| Blood Type | Patient blood group |
| Medical Condition | Diagnosis (e.g., Arthritis, Diabetes, Cancer, Obesity, Hypertension, Asthma) |
| Date of Admission | Admission date |
| Doctor | Attending doctor |
| Hospital | Hospital / facility name |
| Insurance Provider | Insurance company (Cigna, Medicare, Blue Cross, UnitedHealthcare, Aetna) |
| Billing Amount | Total billed amount ($) |
| Room Number | Assigned room |
| Admission Type | Elective / Urgent / Emergency |
| Discharge Date | Discharge date |
| Medication | Prescribed medication |
| Test Results | Normal / Abnormal / Inconclusive |

**Derived metric:** Length of Stay (LOS) = Discharge Date − Date of Admission

---

## 🧹 Data Cleaning (Power Query)

### Overview
This project involved end-to-end data transformation, cleaning, and profiling of the healthcare dataset using **Power Query Editor**. The primary objective was to resolve structural anomalies, standardize text values, fix precision issues in financial metrics, and validate overall data quality before loading into Power BI for analytics.

The raw dataset (`Messy_healthcare_dataset`) was cleaned and transformed into a production-ready model (`Cleaned_healthcare_dataset`), exported as `Cleaned_Health Care Dataset.csv` for use as both the Power BI data source and the source table for the SQL analysis.

<img width="1914" height="1078" alt="power_query_applied_steps" src="https://github.com/user-attachments/assets/a92048e2-de9e-47d2-9c1a-6d9e0ad0c883" />


### Key Data Transformation Steps

**1. Header Promotion & Initial Type Alignment**
- **Promoted First Row as Headers:** Ensured field names (`Name`, `Age`, `Gender`, `Blood Type`, `Medical Condition`, `Billing Amount`, etc.) were properly assigned.
- **Type Casting:** Set initial data types for text, numeric, and date fields so aggregations (such as average age or total billing amount) calculate accurately.

**2. Financial Precision & Rounding**
- **Decimal Rounding:** Applied `Number.Round(_, 2)` to the `Billing Amount` column to reduce 5-decimal floating-point noise (e.g., `18856.28131` → `18856.28`).
- **Data Type Optimization:** Converted the data type to **Fixed Decimal Number** (`$`) to prevent precision errors during DAX calculations and report aggregations.

**3. Text Standardization & Casing**
- **Capitalize Each Word:** Applied title-case formatting across text fields (e.g., patient names) to maintain visual consistency across charts and tables.

**4. Multi-Pass Whitespace & Special Character Removal**
- **Trimmed & Cleaned Text:** Ran iterative `Trim` and `Clean` transformations across text columns to strip hidden leading/trailing spaces and non-printable characters that can cause silent grouping failures or mismatched joins.

**5. Value Replacement & Data Cleaning**
- **Replaced Values:** Removed stray characters and inconsistent punctuation (e.g., replacing `","` with `" "` in Hospital/Provider fields) to consolidate duplicate-looking entries under uniform names.

**6. Column Restructuring**
- **Split Column by Delimiter:** Divided multi-part text fields into distinct, standalone attributes.
- **Merged Columns:** Combined specific attributes where unified fields were required for analysis.

### Data Quality Summary

| Metric | Profile Result | Status |
| :--- | :---: | :---: |
| **Valid Rows** | 100% | ✅ Pass |
| **Error Rate** | 0% | ✅ Pass |
| **Empty Values** | 0% | ✅ Pass |
| **Profiled Columns** | 15 | Active |
| **Sample Profile Depth** | Entire Dataset (999+ rows) | Complete |

> **Conclusion:** The dataset is fully cleaned, standardized, and production-ready for Power BI modeling, DAX measure creation, and visual dashboarding. The subsequent SQL analysis independently re-confirms this (see [SQL Analysis](#️-sql-analysis) below) and surfaces a few additional data-quality caveats worth noting before treating every downstream aggregate as a business signal.

---

<a id="challenges-solutions"></a>

## ⚠️ Challenges & Solutions

Like most real-world datasets, the raw healthcare data wasn't analysis-ready from the start. Below are some of the key challenges encountered during the project and how they were addressed.

### Challenge 1: Inconsistent Text Formatting
Several text fields contained inconsistent capitalization, extra spaces, and hidden characters. These issues can lead to incorrect grouping and duplicate-looking values during analysis.

**Solution:** Used Power Query's **Trim**, **Clean**, **Replace Values**, and text formatting transformations to standardize fields such as Patient Name, Doctor, and Hospital, ensuring accurate filtering and aggregation.

### Challenge 2: Raw Data Was Not Ready for Analysis
The dataset contained mixed data types and formatting inconsistencies, which made calculations and reporting unreliable.

**Solution:** Promoted headers, corrected data types, cleaned text fields, and validated the transformed data using Power Query's column profiling features before loading it into the model.

### Challenge 3: Creating Operational Metrics
The dataset did not directly provide a metric for measuring hospital stay duration, which is an important operational KPI.

**Solution:** Created a **Length of Stay (LOS)** calculation using the difference between **Discharge Date** and **Admission Date**, enabling hospital efficiency and patient care analysis.

### Challenge 4: Converting Raw Data into Business Insights
Having thousands of patient records is useful, but raw numbers alone do not help decision-makers understand what actions to take.

**Solution:** Analyzed trends across patient demographics, medical conditions, hospital performance, admission types, and billing data to identify meaningful insights and provide actionable recommendations.

### Challenge 5: Keeping the Dashboard Simple and Useful
With many available columns and potential visualizations, there was a risk of creating a cluttered dashboard that was difficult to navigate.

**Solution:** Structured the report into dedicated sections — **Executive Summary, Patient Analysis, Financial Analysis, Operational Analysis, Insights, and Recommendations** — allowing users to explore information in a logical and organized way.

### Challenge 6: Hospital- and Doctor-Level Metrics Were Misleadingly Granular
The `Hospital` field contains **39,274 distinct values across 55,500 records** (median 1 patient per hospital), and the `Doctor` field has the same pattern — **40,341 distinct doctors, median 1 patient per doctor**, with the busiest doctor (Michael Smith) topping out at 27 patients. This means row-level "top hospital/doctor by average billing" or "lowest-revenue hospital" queries return single- or few-record outliers rather than repeatable facility- or provider-level patterns.

**Solution:** Documented this explicitly during the SQL analysis (see [SQL Analysis](#️-sql-analysis)) and directly on the Operational Analysis dashboard page rather than presenting single-record extremes as business findings. Hospital- and doctor-performance conclusions are scoped to aggregate/distributional statements (e.g., revenue spread across the network) instead of asserting that a named individual hospital or doctor systematically outperforms — the dataset simply doesn't have enough volume per hospital/doctor to support that claim.

---

## 📊 Dashboard Pages

### 1. Executive Summary
High-level KPIs at a glance: total patients, total revenue, average billing amount, average patient age, average length of stay, total hospitals/doctors, and the most common medical condition — plus trends of patient volume by year and revenue by month.

> **Note on "Total Patients":** this KPI shows **~40K**, which is the count of *distinct patient names* (40,235) — not the 55,500 total admission records. The dataset has 55,500 admission-level rows because a number of patients were admitted more than once; "Total Patients" de-duplicates to unique individuals, while every other metric (revenue, billing, LOS, etc.) is calculated at the record/admission level. Both numbers are correct — they're just answering different questions ("how many people?" vs. "how many hospital visits?").

![Executive Summary](Dashboard%20Screenshot/01_executive_summary.png)

### 2. Patient Analysis
Breakdown of patients by gender, age group, blood type, test results, medical condition, and medication — including medication usage patterns across age groups and gender.

![Patient Analysis](Dashboard%20Screenshot/02_patient_analysis.png)

### 3. Financial Analysis
Revenue performance by hospital, admission type, medical condition, and insurance provider, along with top/bottom billing patients and billing splits by age group and gender.

![Financial Analysis](Dashboard%20Screenshot/03_financial_analysis.png)

### 4. Operational Analysis
Hospital and doctor-level performance: top hospitals/doctors by patient volume, revenue, and average length of stay, plus longest-stay patients and average stay by medical condition.

> **Reading note:** as with hospitals (see [Challenge 6](#challenges-solutions) and [SQL Analysis](#️-sql-analysis)), the `Doctor` field has **40,341 distinct values across 55,500 records — a median of 1 patient per doctor**, and the busiest doctor in the dataset (Michael Smith) tops out at 27 patients. "Top doctor" rankings here should be read as "highest count in this dataset," not as evidence of a doctor who reliably outperforms peers — there isn't enough volume per doctor to draw that conclusion.

![Operational Analysis](Dashboard%20Screenshot/04_operational_analysis.png)

### 5. Insights
Narrative, data-driven observations synthesized from all report pages (patient trends, revenue seasonality, chronic disease burden, demographic spend patterns, and top operational performers).

![Insights](Dashboard%20Screenshot/05_insights.png)

### 6. Recommendations
Actionable recommendations grouped into three themes: Operations & Staffing, Patient Care & Chronic Illness Management, and Financial & Resource Planning.

![Recommendations](Dashboard%20Screenshot/06_recommendations.png)

---

## 🗄️ SQL Analysis

To validate the Power BI findings independently and demonstrate backend query skills, the cleaned dataset was also loaded into SQL Server (`health_care_data` table) and queried directly in **`Healthcare_Analysis.sql`**. The script is organized into six sections, each following a query → insight → (where relevant) recommendation format:

1. **Data Validation & Quality** — row counts, NULL checks, duplicate detection, and billing-amount range checks.
2. **Patient & Demographic Analysis** — gender split, age bands, and medical-condition distribution.
3. **Admission Analysis** — volume, revenue, and average billing by admission type; monthly/yearly admission trends.
4. **Hospital & Revenue Analysis** — revenue and billing rankings by hospital, and above-average-revenue hospital detection.
5. **Medical Condition & Financial Analysis** — revenue and billing patterns by diagnosis.
6. **Advanced SQL Analysis** — window functions (`RANK`, `DENSE_RANK`, `LAG`), CTEs, running totals, and year-over-year growth.

### Key Validated Findings

- **Row count and completeness confirmed:** 55,500 patient records, 0 NULL values across all 15 columns.
- **534 candidate duplicate groups** (1,068 rows) identified by matching Name, Age, Gender, Blood Type, Medical Condition, and Admission Date. These are *candidate* duplicates, not confirmed ones — some overlap is expected by coincidence in a 55K-row dataset with a handful of common attributes, so this is reported as a data-quality flag rather than a hard duplicate count.
- **108 records carry negative billing amounts** (min: **-$2,008.49**), which the Power BI model already excludes from its `Positive Revenue` measure. The SQL analysis keeps them in raw aggregates (e.g., total/average billing) so the two layers are directly comparable, and calls out the effect explicitly rather than silently netting it out.
- **Length of Stay averages 15.5 days**, matching the dashboard's LOS KPI exactly — confirming the DAX and SQL calculations agree.
- **2020–2023 revenue growth is stable** (+50.93% in 2020, then roughly flat ±2% through 2023). **2024 shows a -65.31% year-over-year drop, which is a partial-year artifact, not a real decline** — the dataset's admission records stop at May 7, 2024, so 2024 has only ~5 months of data against a full 12 for prior years. This matches the explanation already given in the [Key Insights](#-key-insights) section below.
- **Hospital-level rankings are low-signal by design:** with 39,274 distinct hospitals across 55,500 patients (median 1 patient per hospital, max 44), single-hospital "highest average billing" or "lowest revenue" results reflect one or two individual bills, not facility performance. These queries are kept in the script for completeness/technique demonstration (`RANK`, `DENSE_RANK`, subqueries) but are **not** treated as standalone business insights — hospital-level revenue is instead described as "spread across the network with no hospital exceeding 5% of total revenue," which is a statistically meaningful statement at that sample size.
- No individual hospital contributes more than **5% of total network revenue** — confirmed via a CTE-based percentage-contribution query, reinforcing that revenue is diversified rather than concentrated.

### Techniques Demonstrated

- Data quality auditing (`COUNT`/`NULL` checks, duplicate detection via `GROUP BY … HAVING`)
- Aggregate and conditional analysis (`CASE` for age banding, filtered `WHERE` for anomaly detection)
- Ranking and window functions (`RANK()`, `DENSE_RANK()`, `LAG()`, partitioned `AVG()`/`SUM()`)
- CTEs for multi-step logic (YoY growth, top-N-per-group, revenue-contribution thresholds)
- Running totals and time-series aggregation (`ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`)

---

## 🔑 Key Insights

- **Patient volume** grew sharply from 6.3K (2019) to a steady ~9.3K/year by 2021–2023; the 2024 dip reflects incomplete year-to-date data (admissions stop May 7, 2024), not an actual decline — confirmed independently in the SQL year-over-year analysis.
- **Arthritis** is the most common medical condition, followed closely by Diabetes — together affecting ~16,000 patients (SQL: 9,308 and 9,304 respectively).
- **Average Length of Stay** is 15.5 days, with an average patient age of ~51.5 years, pointing to a middle-aged/senior-heavy patient base needing extended care. This 15.5-day figure was independently re-derived in SQL and matches exactly.
- Gender distribution is nearly balanced (50.1% Female / 49.9% Male).
- **Emergency ($477.6M)** and **Urgent ($474.0M)** admissions are the largest revenue drivers — together over $951M, ahead of Elective care.
- **Adults and Senior Citizens** account for the vast majority of hospital spend (~$1.05B combined).
- **LLC Smith** leads in patient admissions; **Johnson PLC** is the top revenue-generating hospital; **Michael Smith** is the top-performing doctor by both patient volume and revenue. *(Note: with ~39K distinct hospitals and ~40K distinct doctors — both with a median of roughly 1 patient each — individual hospital/doctor "leaders" should be read as descriptive top-of-list results rather than statistically robust performance signals. See [Challenge 6](#challenges-solutions) and [SQL Analysis](#️-sql-analysis).)*
- Revenue shows seasonal peaks in **July and August** (~$122M+), suggesting demand surges in summer months.
- 108 records (0.2% of the dataset) have negative billing amounts, likely refunds or billing adjustments — flagged for follow-up but not removed, since dropping them would understate raw billing activity.
- The dashboard's **"Total Patients" KPI (~40K)** counts distinct patient names, not the 55,500 total admission records — some patients appear more than once in the dataset. Both figures are correct; they answer different questions (unique people vs. total hospital visits).

---

## 💡 Recommendations Summary

1. **Operations & Staffing** – Reduce the 15.5-day average length of stay via faster discharge planning and outpatient care; balance doctor workload to prevent burnout; replicate best practices from top-performing hospitals network-wide.
2. **Patient Care & Chronic Illness** – Build dedicated clinics for Arthritis and Diabetes management; expand preventative care programs for adult and senior populations.
3. **Financial & Resource Planning** – Scale staffing/supplies ahead of the July–August demand peak; prioritize and protect funding for Emergency and Urgent care, the network's largest revenue contributors; route the 108 negative-billing records to finance for reconciliation rather than leaving them unexplained in reporting.

---

## 🧮 Data Model & DAX Measures

The report is built on a single cleaned fact table (`Cleaned_Dataset`) loaded from `Cleaned_Health Care Dataset.csv` — with data type fixes, a calculated `Days in Hospital` column, and an `Age Band` grouping column added during transformation.

<img width="873" height="618" alt="data_model" src="https://github.com/user-attachments/assets/66852504-040c-43f5-8d3c-02fade123edf" />


A few of the core DAX measures powering the KPIs and visuals:

```dax
Most Common Medical Condition = 
MAXX(
    TOPN(
        1,
        VALUES(Cleaned_Dataset[Medical Condition]),
        CALCULATE(COUNTROWS(Cleaned_Dataset)),
        DESC
    ),
    Cleaned_Dataset[Medical Condition]
)
```
Dynamically returns the medical condition with the highest patient count, used to drive the "Most Common Medical Condition" KPI card on the Executive Summary page.

```dax
Avg Patients per Hospital = 
DIVIDE(
    DISTINCTCOUNT(Cleaned_Dataset[Name]),
    DISTINCTCOUNT(Cleaned_Dataset[Hospital]),
    0
)
```
Calculates the average patient load per hospital, with a safe `DIVIDE` fallback to avoid divide-by-zero errors when filters return no hospitals.

```dax
Positive Revenue = 
CALCULATE(
    SUM(Cleaned_Dataset[Billing Amount]),
    Cleaned_Dataset[Billing Amount] > 0
)
```
Sums only positive billing amounts, filtering out any negative/erroneous billing entries so revenue KPIs aren't skewed by bad data.

Other measures in the model include `Average Patient Age`, `Avg Billing Amount`, and `Avg Length of Stay`, which feed the KPI cards across the Executive Summary, Financial, and Operational Analysis pages.

---

## 🛠️ Skills Demonstrated

- Data cleaning and transformation (Power Query) — text standardization, error/empty value profiling, delimiter splits/merges, and data type correction (see [Data Cleaning](#-data-cleaning-power-query))
- Data modeling and relationship design (see [Data Model & DAX Measures](#-data-model--dax-measures))
- DAX for calculated columns and measures — `TOPN`/`MAXX` ranking logic, safe division with `DIVIDE`, conditional aggregation with `CALCULATE`
- SQL data validation and analysis — NULL/duplicate audits, `CASE`-based segmentation, window functions (`RANK`, `DENSE_RANK`, `LAG`), CTEs, and running totals (see [SQL Analysis](#️-sql-analysis))
- Cross-tool validation — independently re-deriving the same KPIs (LOS, revenue, YoY growth) in both DAX and SQL to confirm consistency
- Interactive dashboard design (slicers, KPI cards, drill-through-ready layout)
- Data storytelling — translating charts and query results into written insights and business recommendations, including flagging where a metric is statistically unreliable (e.g., single-record hospital rankings) rather than over-claiming
- Healthcare domain analysis (patient demographics, billing, operational KPIs)

---

## 🛠️ Tools & Techniques Used

- **Power BI Desktop** – data modeling, DAX measures, interactive visuals
- **Power Query** – data cleaning and transformation
- **DAX** – calculated KPIs (Length of Stay, Revenue by Month, Top N rankings, etc.)
- **SQL Server (T-SQL)** – data validation, aggregate analysis, CTEs, and window functions (`Healthcare_Analysis.sql`)
- Interactive slicers: Year, Hospital, Doctor, Gender
- Custom themed report pages with consistent branding

---

## 🚀 How to Use

1. Clone or download this repository.
2. Open `Healthcare Analysis.pbix` in **Power BI Desktop** (2021 or later recommended).
3. If prompted, update the data source path to point to `Cleaned_Health Care Dataset.csv` on your machine (this is the file the report is built on). To compare against the pre-cleaning state, you can also load `Messy_healthcare_dataset.csv` or the raw sheet inside `Health Care Dataset.xlsx`.
4. Use the **Year / Hospital / Doctor / Gender** slicers on each page to filter the analysis.
5. Navigate between report pages using the tabs at the bottom of the dashboard.
6. To explore the SQL analysis, load `Cleaned_Health Care Dataset.csv` into SQL Server (or your preferred RDBMS) as a table named `health_care_data`, then run the queries in `Healthcare_Analysis.sql` — each query is preceded by its business question and followed by its insight as inline comments.

---

## 📈 Future Enhancements

- 🔄 **Forecasting** *(in progress)* – Predictive modeling for future patient admissions and revenue trends.
- Incorporate readmission rate tracking
- Add a cost-per-condition or profitability analysis by department
- Automate data refresh via a live database/API connection
- Re-run hospital-level rankings with a minimum patient-count threshold (e.g., `HAVING COUNT(*) >= 20`) to produce statistically meaningful "top/bottom hospital" comparisons, given the current dataset's near-unique hospital-per-patient structure

> **Note:** SQL data validation and analysis is complete as of this update (see [SQL Analysis](#️-sql-analysis)). Forecasting is the remaining item in progress and will be added in a future update.

---

## 📄 Data Source & Disclaimer

This dataset is used for **educational and portfolio purposes only**. Patient names, doctors, and hospital names are synthetic/randomly generated and do not represent real individuals or institutions. Billing figures and medical details are illustrative and should not be used for actual clinical, financial, or operational decision-making.

---

## 👤 Author

Prepared as a healthcare analytics portfolio project demonstrating end-to-end analytics — from raw data cleaning through Power BI reporting and independent SQL validation — to executive insights and recommendations.
