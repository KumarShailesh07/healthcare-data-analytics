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
7. [Challenges & Solutions](#challenges-solutions)
8. [Dashboard Pages](#-dashboard-pages)
9. [Key Insights](#-key-insights)
10. [Recommendations Summary](#-recommendations-summary)
11. [Data Model & DAX Measures](#-data-model--dax-measures)
12. [Skills Demonstrated](#️-skills-demonstrated)
13. [Tools & Techniques Used](#️-tools--techniques-used)
14. [How to Use](#-how-to-use)
15. [Future Enhancements](#-future-enhancements)
16. [Data Source & Disclaimer](#-data-source--disclaimer)
17. [Author](#-author)

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
 
| File / Folder | Description |
|---|---|
| `Health Care Dataset.xlsx` | Source workbook containing **both** the messy (raw) and cleaned versions of the dataset as separate sheets (~55.5K patient records) |
| `Cleaned_Health Care Dataset.csv` | Standalone CSV export of the cleaned data — a separate CSV file containing the cleaned dataset, useful for reviewing the final cleaning output without opening the original Excel file. |
| `Messy_healthcare_dataset.csv` | Standalone CSV export of the raw, uncleaned data — useful for viewing the pre-cleaning state without opening Excel |
| `Healthcare Analysis.pbix` | Power BI report file (dashboard + data model), built by loading the **cleaned sheet** from `Health Care Dataset.xlsx` |
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

## Overview
This project focuses on the end-to-end data transformation, cleaning, and profiling of a healthcare dataset using **Power Query Editor**. The primary objective is to resolve structural anomalies, standardize text values, adjust precision for financial metrics, and validate overall data quality before loading into Power BI for analytics.

---

## 🧹 Data Cleaning & Transformation Pipeline

The raw dataset (`Messy_healthcare_dataset`) was cleaned and transformed into a production-ready model (`Cleaned_healthcare_dataset`). Below is the applied transformation sequence in Power Query:

![Power Query Applied Steps](https://github.com/user-attachments/assets/9bc5bf94-95ae-4c64-994d-853f00765ce0)

### Key Transformation Steps Applied:

- **Promoted Headers & Type Casting:** Standardized headers and assigned explicit data types (Text, Whole Number, Date, Fixed Decimal) to fields like `Age`, `Billing Amount`, and `Discharge Date` to enable seamless DAX aggregations.
- **Financial Precision & Rounding:** Applied `Number.Round(_, 2)` to `Billing Amount` to eliminate 5-decimal floating-point noise (`18856.28131` $\rightarrow$ `18856.28`) and converted data type to **Fixed Decimal Number** (`$`).
- **Text Standardization:** Enforced title casing using *Capitalize Each Word* across text fields like patient names for clean visual presentation.
- **Multi-Pass Whitespace & Special Character Removal:** Applied `Trim` and `Clean` operations to remove hidden leading/trailing spaces and non-printable characters.
- **Value Replacement:** Consolidated inconsistent text entries (e.g., stripping stray commas like `","` in Hospital/Provider names).
- **Column Restructuring:** Utilized `Split Column by Delimiter` and `Merged Columns` to restructure multi-part fields into clear analysis-ready dimensions.

---

## 📊 Data Quality & Profiling Results

Based on Power Query's column profiling across the entire dataset (999+ rows, 15 columns):

| Profiling Metric | Result | Status |
| :--- | :---: | :---: |
| **Valid Values** | 100% | ✅ Passed |
| **Error Rate** | 0% | ✅ Passed |
| **Empty Values** | 0% | ✅ Passed |

> **Status:** Dataset is 100% cleaned, validated, and ready for data modeling, DAX measures, and dashboard visualization.

---

## Key Data Transformation Steps

### 1. Header Promotion & Initial Type Alignment
- **Promoted First Row as Headers:** Ensured field names (`Name`, `Age`, `Gender`, `Blood Type`, `Medical Condition`, `Billing Amount`, etc.) were properly assigned.
- **Type Casting:** Set initial data types for text, numeric, and date fields so aggregations (such as average age or total billing amount) calculate accurately.

### 2. Financial Precision & Rounding
- **Decimal Rounding:** Applied `Number.Round(_, 2)` to the `Billing Amount` column to reduce 5-decimal floating-point numbers (e.g., `18856.28131`) to standard currency format (`18856.28`).
- **Data Type Optimization:** Converted the data type to **Fixed Decimal Number** (`$`) to prevent precision errors during DAX calculations and report aggregations.

### 3. Text Standardization & Casing
- **Capitalize Each Word:** Applied title-case formatting across text fields (e.g., Patient Names) to maintain visual consistency across charts and tables.

### 4. Multi-Pass Whitespace & Special Character Removal
- **Trimmed & Cleaned Text:** Ran iterative `Trim` and `Clean` transformations across text columns to strip hidden leading/trailing spaces and non-printable characters that can cause silent grouping failures or mismatched joins.

### 5. Value Replacement & Data Cleaning
- **Replaced Values:** Removed stray characters and inconsistent punctuation (e.g., replacing `","` with `" "` in Hospital/Provider fields) to consolidate duplicate entries under uniform names.

### 6. Column Restructuring
- **Split Column by Delimiter:** Divided multi-part text fields into distinct, standalone attributes.
- **Merged Columns:** Combined specific attributes where unified fields were required for analysis.

---

## Data Quality Summary

| Metric | Profile Result | Status |
| :--- | :---: | :---: |
| **Valid Rows** | 100% | Pass |
| **Error Rate** | 0% | Pass |
| **Empty Values** | 0% | Pass |
| **Profiled Columns** | 15 | Active |
| **Sample Profile Depth** | Entire Dataset (999+ rows) | Complete |

> **Conclusion:** The dataset is fully cleaned, standardized, and production-ready for Power BI modeling, DAX measure creation, and visual dashboarding.

---

<a id="challenges-solutions"></a>

## ⚠️ Challenges & Solutions

Like most real-world datasets, the raw healthcare data wasn't analysis-ready from the start. Below are some of the key challenges encountered during the project and how they were addressed.

### Challenge 1: Inconsistent Text Formatting

Several text fields contained inconsistent capitalization, extra spaces, and hidden characters. These issues can lead to incorrect grouping and duplicate-looking values during analysis.

**Solution:**
Used Power Query's **Trim**, **Clean**, **Replace Values**, and text formatting transformations to standardize fields such as Patient Name, Doctor, and Hospital, ensuring accurate filtering and aggregation.

---

### Challenge 2: Raw Data Was Not Ready for Analysis

The dataset contained mixed data types and formatting inconsistencies, which made calculations and reporting unreliable.

**Solution:**
Promoted headers, corrected data types, cleaned text fields, and validated the transformed data using Power Query's column profiling features before loading it into the model.

---

### Challenge 3: Creating Operational Metrics

The dataset did not directly provide a metric for measuring hospital stay duration, which is an important operational KPI.

**Solution:**
Created a **Length of Stay (LOS)** calculation using the difference between **Discharge Date** and **Admission Date**, enabling hospital efficiency and patient care analysis.

---

### Challenge 4: Converting Raw Data into Business Insights

Having thousands of patient records is useful, but raw numbers alone do not help decision-makers understand what actions to take.

**Solution:**
Analyzed trends across patient demographics, medical conditions, hospital performance, admission types, and billing data to identify meaningful insights and provide actionable recommendations.

---

### Challenge 5: Keeping the Dashboard Simple and Useful

With many available columns and potential visualizations, there was a risk of creating a cluttered dashboard that was difficult to navigate.

**Solution:**
Structured the report into dedicated sections — **Executive Summary, Patient Analysis, Financial Analysis, Operational Analysis, Insights, and Recommendations** — allowing users to explore information in a logical and organized way.

---

## 📊 Dashboard Pages

### 1. Executive Summary
High-level KPIs at a glance: total patients, total revenue, average billing amount, average patient age, average length of stay, total hospitals/doctors, and the most common medical condition — plus trends of patient volume by year and revenue by month.

<img width="737" height="440" alt="Screenshot 2026-08-10 214204" src="https://github.com/user-attachments/assets/57514326-08cb-4d5e-8572-07646e831e60" />


### 2. Patient Analysis
Breakdown of patients by gender, age group, blood type, test results, medical condition, and medication — including medication usage patterns across age groups and gender.

<img width="733" height="412" alt="Screenshot 2026-08-10 214225" src="https://github.com/user-attachments/assets/2a89bca8-21ec-4191-9ef7-1d78467128bf" />


### 3. Financial Analysis
Revenue performance by hospital, admission type, medical condition, and insurance provider, along with top/bottom billing patients and billing splits by age group and gender.

<img width="733" height="410" alt="Screenshot 2026-08-10 214241" src="https://github.com/user-attachments/assets/e186969c-28a7-42a3-bfe7-63c2113da99d" />


### 4. Operational Analysis
Hospital and doctor-level performance: top hospitals/doctors by patient volume, revenue, and average length of stay, plus longest-stay patients and average stay by medical condition.

<img width="736" height="408" alt="Screenshot 2026-08-10 214259" src="https://github.com/user-attachments/assets/69a0aa10-4118-4c2a-8bb7-89c2aba908b9" />


### 5. Insights
Narrative, data-driven observations synthesized from all report pages (patient trends, revenue seasonality, chronic disease burden, demographic spend patterns, and top operational performers).

<img width="727" height="413" alt="Screenshot 2026-08-10 214315" src="https://github.com/user-attachments/assets/edd0c1e6-e80c-4ab1-8c57-975ab3c311ed" />


### 6. Recommendations
Actionable recommendations grouped into three themes: Operations & Staffing, Patient Care & Chronic Illness Management, and Financial & Resource Planning.

<img width="731" height="409" alt="Screenshot 2026-08-10 214333" src="https://github.com/user-attachments/assets/64d581de-8047-4a1a-9b6a-f6f8ce930a07" />


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

<img width="437" height="309" alt="Screenshot 2026-08-10 225952" src="https://github.com/user-attachments/assets/04222a9e-f9b8-499d-af8d-2362e677381b" />


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
