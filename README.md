# 🏥 Healthcare Analysis Dashboard (Power BI)

An interactive Power BI dashboard built to analyze hospital operations, patient demographics, and financial performance across a multi-hospital healthcare network from **2019–2024**.

---

## 📑 Table of Contents

1. [Problem Statement](#-problem-statement)
2. [Objectives](#-objectives--key-business-questions)
3. [Project Overview](#-project-overview)
4. [Repository Contents](#-repository-contents)
5. [Dataset Description](#️-dataset-description)
6. [Data Cleaning (Power Query)](#-data-cleaning-power-query)
7. [Dashboard Pages](#-dashboard-pages)
8. [Key Insights](#-key-insights)
9. [Recommendations Summary](#-recommendations-summary)
10. [Data Model & DAX Measures](#-data-model--dax-measures)
11. [Skills Demonstrated](#️-skills-demonstrated)
12. [Tools & Techniques Used](#️-tools--techniques-used)
13. [How to Use](#-how-to-use)
14. [Future Enhancements](#-future-enhancements)
15. [Data Source & Disclaimer](#-data-source--disclaimer)
16. [Author](#-author)

---

## 🎯 Problem Statement

Hospital networks generate large volumes of patient, billing, and operational data every day, but this data is often scattered across systems and rarely consolidated into a single, decision-ready view. Without a unified reporting layer, hospital administrators struggle to answer basic but critical questions — which hospitals or doctors are over/under-performing, which medical conditions are driving cost and length of stay, and where revenue is actually coming from.

This project addresses that gap by consolidating a ~55,500-record patient dataset into a single Power BI dashboard, enabling stakeholders to monitor patient trends, financial performance, and operational efficiency in one place, and to make faster, data-backed decisions on staffing, resource planning, and chronic care management.

---

## ❓ Objectives / Key Business Questions

This dashboard was built to answer questions such as:

- How is patient volume trending year over year, and are there seasonal patterns in admissions or revenue?
- Which medical conditions are most common, and which drive the highest cost and longest stays?
- Which hospitals and doctors are the top (and bottom) performers by patient volume, revenue, and average length of stay?
- Where does hospital revenue actually come from — admission type, insurance provider, age group, or medical condition?
- What operational changes (staffing, discharge planning, specialized clinics) could most improve efficiency and patient outcomes?

---

## 📌 Project Overview

This project transforms a raw healthcare dataset (~55,500 patient records) into a decision-ready Power BI report. It covers patient trends, revenue drivers, medical conditions, doctor/hospital performance, and operational efficiency, wrapped up with data-driven insights and recommendations for hospital administrators.

---

## 📂 Repository Contents

| File | Description |
|---|---|
| `Health_Care_Dataset.csv` | Raw source dataset (~55.5K patient records) |
| `Healthcare_Analysis.pbix` | Power BI report file (dashboard + data model) |
| `screenshots/` | Preview images of each report page |
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

The raw dataset (`Messy_healthcare_dataset`) was cleaned and transformed in Power Query before being loaded into the model as `Cleaned_healthcare_dataset`. Key applied steps included:

![Data Cleaning](screenshots/08_data_cleaning.png)

- **Promoted headers** and corrected column data types (text, numeric, date) so fields like Age and Billing Amount could be aggregated correctly.
- **Capitalized each word** in text fields (e.g., patient names) for consistent formatting.
- **Trimmed and cleaned text** across multiple columns (applied twice — `Trimmed Text` / `Trimmed Text1` / `Trimmed Text2` and `Cleaned Text` / `Cleaned Text1` / `Cleaned Text2`) to remove extra whitespace and non-printable characters that can silently break grouping and filtering.
- **Replaced values** — including stripping stray characters (e.g., replacing `" ,"` with `" "` in the Hospital column) to standardize inconsistent entries.
- **Split columns by delimiter** (applied twice) to break combined fields into separate, usable columns.
- **Merged columns** where fields needed to be recombined after splitting/cleaning.

The result is a clean, analysis-ready table with 15 columns and 999+ rows, 0% errors and 0% empty values across the profiled fields (Name, Age, Gender, Blood Type, Medical Condition), as confirmed by Power Query's column quality profiling.

---

## 📊 Dashboard Pages

### 1. Executive Summary
High-level KPIs at a glance: total patients, total revenue, average billing amount, average patient age, average length of stay, total hospitals/doctors, and the most common medical condition — plus trends of patient volume by year and revenue by month.

![Executive Summary](screenshots/01_executive_summary.png)

### 2. Patient Analysis
Breakdown of patients by gender, age group, blood type, test results, medical condition, and medication — including medication usage patterns across age groups and gender.

![Patient Analysis](screenshots/02_patient_analysis.png)

### 3. Financial Analysis
Revenue performance by hospital, admission type, medical condition, and insurance provider, along with top/bottom billing patients and billing splits by age group and gender.

![Financial Analysis](screenshots/03_financial_analysis.png)

### 4. Operational Analysis
Hospital and doctor-level performance: top hospitals/doctors by patient volume, revenue, and average length of stay, plus longest-stay patients and average stay by medical condition.

![Operational Analysis](screenshots/04_operational_analysis.png)

### 5. Insights
Narrative, data-driven observations synthesized from all report pages (patient trends, revenue seasonality, chronic disease burden, demographic spend patterns, and top operational performers).

![Insights](screenshots/05_insights.png)

### 6. Recommendations
Actionable recommendations grouped into three themes: Operations & Staffing, Patient Care & Chronic Illness Management, and Financial & Resource Planning.

![Recommendations](screenshots/06_recommendations.png)

---

## 🔑 Key Insights

- **Patient volume** grew sharply from 6.3K (2019) to a steady ~9.3K/year by 2021–2023; the 2024 dip reflects incomplete year-to-date data, not an actual decline.
- **Arthritis** is the most common medical condition, followed closely by Diabetes — together affecting ~16,000 patients.
- **Average Length of Stay** is 15.5 days, with an average patient age of ~51.5 years, pointing to a middle-aged/senior-heavy patient base needing extended care.
- Gender distribution is nearly balanced (50.1% Female / 49.9% Male).
- **Emergency ($477.6M)** and **Urgent ($474.0M)** admissions are the largest revenue drivers — together over $951M, ahead of Elective care.
- **Adults and Senior Citizens** account for the vast majority of hospital spend (~$1.05B combined).
- **LLC Smith** leads in patient admissions; **Johnson PLC** is the top revenue-generating hospital; **Michael Smith** is the top-performing doctor by both patient volume and revenue.
- Revenue shows seasonal peaks in **July and August** (~$122M+), suggesting demand surges in summer months.

---

## 💡 Recommendations Summary

1. **Operations & Staffing** – Reduce the 15.5-day average length of stay via faster discharge planning and outpatient care; balance doctor workload to prevent burnout; replicate best practices from top-performing hospitals network-wide.
2. **Patient Care & Chronic Illness** – Build dedicated clinics for Arthritis and Diabetes management; expand preventative care programs for adult and senior populations.
3. **Financial & Resource Planning** – Scale staffing/supplies ahead of the July–August demand peak; prioritize and protect funding for Emergency and Urgent care, the network's largest revenue contributors.

---

## 🧮 Data Model & DAX Measures

The report is built on a single cleaned fact table (`Cleaned_Dataset`) derived from the raw CSV via Power Query — with data type fixes, a calculated `Days in Hospital` column, and an `Age Band` grouping column added during transformation.

![Data Model](screenshots/07_data_model.png)

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
- Interactive dashboard design (slicers, KPI cards, drill-through-ready layout)
- Data storytelling — translating charts into written insights and business recommendations
- Healthcare domain analysis (patient demographics, billing, operational KPIs)

---

## 🛠️ Tools & Techniques Used

- **Power BI Desktop** – data modeling, DAX measures, interactive visuals
- **Power Query** – data cleaning and transformation
- **DAX** – calculated KPIs (Length of Stay, Revenue by Month, Top N rankings, etc.)
- Interactive slicers: Year, Hospital, Doctor, Gender
- Custom themed report pages with consistent branding

---

## 🚀 How to Use

1. Clone or download this repository.
2. Open `Healthcare_Analysis.pbix` in **Power BI Desktop** (2021 or later recommended).
3. If prompted, update the data source path to point to `Health_Care_Dataset.csv` on your machine.
4. Use the **Year / Hospital / Doctor / Gender** slicers on each page to filter the analysis.
5. Navigate between report pages using the tabs at the bottom of the dashboard.

---

## 📈 Future Enhancements

- 🔄 **SQL Analysis** *(in progress)* – Deeper querying of the dataset (e.g., cohort analysis, readmission patterns, revenue trends by segment) using SQL, to complement the Power BI visuals with backend data validation and ad-hoc analysis.
- 🔄 **Forecasting** *(in progress)* – Predictive modeling for future patient admissions and revenue trends.
- Incorporate readmission rate tracking
- Add a cost-per-condition or profitability analysis by department
- Automate data refresh via a live database/API connection

> **Note:** SQL analysis and forecasting are currently underway and will be added to this project soon, along with an updated README reflecting the new findings.

---

## 📄 Data Source & Disclaimer

This dataset is used for **educational and portfolio purposes only**. Patient names, doctors, and hospital names are synthetic/randomly generated and do not represent real individuals or institutions. Billing figures and medical details are illustrative and should not be used for actual clinical, financial, or operational decision-making.

---

## 👤 Author

Prepared as a healthcare analytics portfolio project demonstrating end-to-end Power BI reporting — from raw data to executive insights and recommendations.
