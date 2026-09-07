-- =============================================================================
-- Project     : Healthcare Data Analytics
-- File        : Healthcare_Analysis.sql
-- Author      : Shailesh Kumar
-- Database    : SQL Server (T-SQL)
-- Source Table: health_care_data  (loaded from Cleaned_Health Care Dataset.csv)
-- Dataset     : ~55,500 patient admission records | 2019-2024
-- Description : Standalone SQL analysis layer for the Healthcare Data Analytics
--               project. Independently validates and re-derives the KPIs shown
--               in the companion Power BI dashboard, and documents data-quality
--               caveats (negative billing, partial-year 2024 data, high-
--               cardinality Hospital/Doctor fields) before treating any
--               aggregate as a business insight.
-- Sections    : 1. Data Validation & Quality
--               2. Patient & Demographic Analysis
--               3. Admission Analysis
--               4. Hospital & Revenue Analysis
--               5. Medical Condition & Financial Analysis
--               6. Advanced SQL Analysis (CTEs, window functions, running totals)
--				 7. Project Conclusion
-- Repository  : https://github.com/KumarShailesh07/healthcare-data-analytics.git
-- =============================================================================


-- To see full data
select * from health_care_data;

--1. Data Validation & Quality
--------------------------------------

--Find the total number of patient records.
select count(*) as [Total Number of Patient]
from health_care_data;

-- Insigts:
--------------
-- The total number of patient records in the healthcare network is 55,500.
-- This indicates a large volume of patient records in the healthcare network.


--Check for duplicate patient records.
select 
	Name,
	Age,
	Gender,
	Blood_Type,
	Medical_Condition,
	Date_of_Admission,
	count(*) as [Record Count]
from health_care_data
group by 
	Name,
	Age,
	Gender,
	Blood_Type,
	Medical_Condition,
	Date_of_Admission
having count(*) > 1;

-- Insigts:
--------------
-- I checked for potential duplicate records based on key patient attributes and the date of admission.
-- The analysis identified 534 potential duplicate groups.


--Identify columns containing NULL values.
select 
	count(*) - count(Name) as [Name Null],
	count(*) - count(Age) as [Age Null],
	count(*) - count(Gender) as [Gender Null],
	count(*) - count(Blood_Type) as [Blood Type Null],
	count(*) - count(Medical_Condition) as [Medical Condition Null],
	count(*) - count(Date_of_Admission) as [Date of Admission Null],
	count(*) - count(Doctor) as [Doctor Null],
	count(*) - count(Hospital) as [Hospital Null],
	count(*) - count(Insurance_Provider) as [Insurance Provider Null],
	count(*) - count(Billing_Amount) as [Billing Amount Null],
	count(*) - count(Room_Number) as [Room Number Null],
	count(*) - count(Admission_Type) as [Admission Type Null],
	count(*) - count(Discharge_Date) as [Discharge Date Null],
	count(*) - count(Medication) as [Medication Null],
	count(*) - count(Test_Results) as [Test_Results Null]
from health_care_data;

-- Insights:
--------------
-- No NULL values were identified in any column of the healthcare dataset,
-- indicating that the dataset is complete with respect to missing values.

--Identify records with negative billing amounts.
select *
from health_care_data
where Billing_Amount < 0;

-- Insights:
-----------------
-- I identified patient records with negative billing amounts.
-- These negative values may represent refunds, billing adjustments, or other financial corrections
-- and should be investigated before being removed during data cleaning.


--Find the minimum, maximum, average, and total billing amount.
select 
	MIN(Billing_Amount) as [Minimum Billing Amount],
	MAX(Billing_Amount) as [Maximum Billing Amount],
	AVG(Billing_Amount) as [Average Billing Amount],
	SUM(Billing_Amount) as [Total Billing Amount]
from health_care_data;

-- Insights:
--------------
-- The minimum billing amount is -$2,008.49.
-- This negative value may represent a refund, billing adjustment, or other financial correction
-- and should be investigated before being treated as an error.

-- The maximum billing amount is $52,764.28.

-- The average billing amount is $25,539.31.

-- The total billing amount across all patient records is approximately $1.417 billion.


--2. Patient & Demographic Analysis 
--------------------------------------

--Find the number of patients by gender.
select 
	Gender,
	count(*) as [Total Number of Patient],
	round(count(*) * 100.0 / sum(count(*)) over (), 2) as [Percentage Distribution]
from health_care_data
group by Gender;

-- Insights:
----------------
-- The healthcare network recorded 27,774 male and 27,726 female patient records.
-- The patient distribution is nearly balanced across genders, with males accounting for
-- 50.04% and females 49.96%, a difference of only 48 records.

--Calculate the percentage distribution of patients by gender.
select 
	Gender,
	ROUND(count(*) * 100.0 / sum(count(*)) over(), 2) as [Patient Distribution Percentage]
from health_care_data
group by Gender;

-- Insights:
-----------------
-- The patient distribution is nearly balanced between genders, 
-- with males accounting for 50.04% and females 49.96%.
-- This indicates a balanced representation of both genders.

--Find the average age of patients.
select 
	AVG(Age) as [Average Patient Age]
from health_care_data;

-- Insights:-
------------------
-- The average age of patients in the healthcare network is approximately 51 years.
-- This indicates that the patient population has a relatively mature age profile.
-- Healthcare services and facilities should consider the needs of middle-aged
-- and older patients when planning resources and patient care.


--Find the number of patients in each age group.
select 
	case
		when Age <= 18 then 'Teenager'
		when Age > 18 and Age <= 35 then 'Young Adult'
		when Age > 35 and Age <= 60 then 'Adult'
		else 'Senior Citizen'
	end as 'Age_Band',
	count(*) as [Total Patient]
from health_care_data
group by 
	case
		when Age <= 18 then 'Teenager'
		when Age > 18 and Age <= 35 then 'Young Adult'
		when Age > 35 and Age <= 60 then 'Adult'
		else 'Senior Citizen'
	end;

-- Insights:
---------------
-- The analysis shows the distribution of patients across different age groups
-- within the healthcare network.

-- There are 888 Teenagers,
-- 13,644 Young Adults,
-- 20,598 Adults,
-- and 20,370 Senior Citizens.

-- Adults represent the largest patient group with 20,598 patients,
-- followed by Senior Citizens with 20,370 patients.
-- Young Adults account for 13,644 patients,
-- while Teenagers represent the smallest group with 888 patients.


-- Recommendation:
----------------------
-- Healthcare services should prioritize capacity, treatment facilities,
-- and patient-support services for Adults and Senior Citizens,
-- as these two groups have the highest number of patients.


-- Business Impact:
-------------------------
-- Focusing resources and services on Adults and Senior Citizens
-- can help the healthcare network manage the needs of its largest
-- patient groups and improve operational efficiency and patient experience.


--Find the number of patients by medical condition.
select 
	Medical_Condition,
	count(*) as [Total Patients]
from health_care_data
group by Medical_Condition;

-- Insights:
-----------------
-- The analysis shows the distribution of patients across different medical conditions
-- within the healthcare network.

-- There are 9304 Diabetes patients,
-- 9227 Cancer patients,
-- 9308 Arthritis patients,
-- 9185 Asthma patients,
-- 9245 Hypertension patients,
-- and 9231 Obesity patients.

-- Arthritis disease has the largest volume of patients (9308),
-- closely followed by Diabetes (9304),
-- while Asthma has the least number of patients (9185).

-- Recommendation:
---------------------
-- Healthcare services should maintain proper treatment facilities,
-- capacity, and patient-support services for all major medical conditions,
-- with more attention to Arthritis and Diabetes because they have
-- slightly higher numbers of patients.

-- Business Impact:
-----------------------
-- Providing proper treatment facilities and sufficient resources
-- can help the healthcare network manage patient demand effectively
-- and maintain better service quality for patients.


--Find the top 5 medical conditions by patient count.
select 
	top 5 Medical_Condition,
	count(*) as [Total Patients]
from health_care_data
group by Medical_Condition
order by [Total Patients] desc;

-- Insights:
---------------
-- The analysis shows the top 5 medical conditions based on the number of patients
-- within the healthcare network.

-- Arthritis disease has the largest volume of patients (9308),
-- closely followed by Diabetes (9304),
-- Hypertension has 9245 patients,
-- Obesity has 9231 patients,
-- and Cancer has 9227 patients.

-- Arthritis has the highest number of patients,
-- while Cancer has the lowest number of patients among the top 5 medical conditions.


--Find the average age for each medical condition.
select 
	Medical_Condition,
	AVG(CAST(Age as decimal(10,2))) as [Average Age]
from health_care_data
group by Medical_Condition
order by [Average Age] desc;

-- Insights:
---------------
-- The analysis shows the average age of patients for each medical condition
-- within the healthcare network.

-- It is quite interesting that the average age of patients across all
-- medical conditions is approximately 51 years.

-- Hypertension has the highest average patient age (51.74),
-- while Obesity has the lowest average patient age (51.24).

-- This indicates that the average age of patients is very similar
-- across all six medical conditions.

-- The difference between the highest and lowest average age is only about 0.50 years, 
-- indicating that patient age is very similar across all six medical conditions.



--3. Admission Analysis 
--------------------------

--Find the number of patients by admission type.
select 
	Admission_Type,
	count(*) as [Total Patients]
from health_care_data
group by Admission_Type
order by [Total Patients] desc;

-- Insights:
-----------------
-- The analysis shows the distribution of patients across different admission types
-- within the healthcare network.

-- The Elective admission type has the largest volume of patients (18655),
-- followed by Urgent (18576),
-- and Emergency (18269).

-- All three admission types have almost similar volume of patients,
-- which indicates that patient demand is relatively balanced across
-- the different admission types.

-- Recommendation:
---------------------
-- Healthcare services should maintain proper treatment facilities,
-- capacity, and patient-support services for all admission types
-- to manage the patient demand effectively.

-- Business Impact:
------------------------
-- Maintaining sufficient facilities and resources across all admission types
-- can help the healthcare network manage patient demand effectively
-- and maintain consistent quality of service.


--Calculate the percentage of patients for each admission type.
select 
	Admission_Type,
	count(*) as [Total Patients],
	ROUND(
		count(*) * 100.0 / sum(count(*)) over () 
		, 2) as [Percentage distribution]
from health_care_data
group by Admission_Type;

-- Insights:
-----------------
-- The analysis shows the percentage distribution of patients
-- across different admission types within the healthcare network.

-- Elective admission has the highest percentage of patients (33.61%),
-- followed by Urgent (33.47%),
-- and Emergency has the lowest percentage (32.92%).

-- All three admission types have almost similar percentage distribution,
-- which indicates that the patient volume is relatively balanced
-- across the different admission types.


--Find the average billing amount by admission type.
select 
	Admission_Type,
	ROUND(AVG(Billing_Amount), 2) as [Average Billing Amount]
from health_care_data
group by Admission_Type
order by [Average Billing Amount] desc;

-- Insights:
-------------
-- This analysis identifies the average billing amount by admission type.

-- Elective has the highest average billing amount,
-- which is $25,602.23.

-- Emergency has the lowest average billing amount,
-- which is $25,497.40.

-- The difference between the highest and lowest average billing amounts
-- is only $104.83, indicating that the average billing amount is
-- relatively balanced across the different admission types.


--Find the total revenue by admission type.
select 
	Admission_Type,
	ROUND(SUM(Billing_Amount), 2) as [Total Revenue]
from health_care_data
group by Admission_Type
order by [Total Revenue] desc;

-- Insights:
-------------
-- This analysis identifies the total revenue by admission type.

-- Elective has the highest total revenue,
-- which is approximately $477.61M.

-- Emergency has the lowest total revenue,
-- which is approximately $465.81M.

-- The difference between the highest and lowest total revenue
-- is approximately $11.80M, indicating that the total revenue
-- is relatively balanced across the different admission types.



--Identify the admission type generating the highest revenue.
select 
	top 1 Admission_Type,
	ROUND(SUM(Billing_Amount), 2) as [Total Revenue]
from health_care_data
group by Admission_Type
order by [Total Revenue] desc;

-- Insights:
-------------
-- This analysis identifies the admission type generating the highest revenue.

-- The Elective admission type generates the highest revenue,
-- which is approximately $477.61M.


--Analyze admissions by year and month.
select 
	Admission_Type,
	FORMAT(Date_of_Admission, 'yyyy-MM') as [Year-Month],
	count(*) as [Total Admission]
from health_care_data
group by Admission_Type,
		 FORMAT(Date_of_Admission, 'yyyy-MM')
order by [Year-Month] asc;

-- Insights:
-------------
-- This analysis identifies the number of admissions by admission type
-- across each year and month.

-- In May 2019, the Elective admission type recorded the highest number
-- of admissions, with 244 admissions.

-- In May 2024, the Urgent admission type recorded the lowest number
-- of admissions, with 72 admissions.



--Find the month/year with the highest number of admissions.
select 
	top 1
	FORMAT(Date_of_Admission, 'yyyy-MM') as [Year-Month],
	count(*) as [Total Admission]
from health_care_data
group by 
		 FORMAT(Date_of_Admission, 'yyyy-MM')
order by [Total Admission] desc;

-- Insights:
-------------
-- This analysis identifies the month/year with the highest number of admissions.

-- August 2020 recorded the highest number of admissions,
-- with a total of 1,014 admissions.


--4. Hospital & Revenue Analysis 
--------------------------------------

--Find the total revenue generated by each hospital.
select 
	Hospital,
	SUM(Billing_Amount) as [Total Revenue]
from health_care_data
group by Hospital
order by [Total Revenue] desc;

-- Insights:
-------------
-- Johnson PLC generated the highest total revenue among the hospitals,
-- with approximately $1.08M in revenue.

-- Medina Elliott Stewart recorded the lowest total revenue,
-- with approximately -$2,633.24.

-- The negative total revenue for Medina Elliott Stewart is notable
-- and may indicate that refunds or billing adjustments exceeded
-- the positive billing amounts recorded for this hospital.

-- This finding may warrant further investigation into the billing
-- and refund patterns of the hospital.


--Find the top 10 hospitals by revenue.
select top 10
	Hospital,
	SUM(Billing_Amount) as [Total Revenue]
from health_care_data
group by Hospital
order by [Total Revenue] desc;

-- Insights:
-------------
-- This analysis identifies the top 10 hospitals based on total revenue.

-- Johnson PLC generated the highest total revenue among the top 10 hospitals,
-- with approximately $1.08M.

-- Smith Group generated the lowest revenue among the top 10 hospitals,
-- with approximately $806.63K.

-- The difference between the highest and lowest revenue within the top 10
-- hospitals is approximately $277.57K, indicating a noticeable variation
-- in revenue generation among the top-performing hospitals.


--Find the top 10 hospitals by patient count.
select top 10
	Hospital,
	COUNT(*) as [Total Patients]
from health_care_data
group by Hospital
order by [Total Patients] desc;

-- Insights:
-------------
-- This analysis identifies the top 10 hospitals based on total patient count.

-- LLC Smith has the highest patient count among the top 10 hospitals,
-- with 44 patients.

-- Group Smith has the lowest patient count among the top 10 hospitals,
-- with 32 patients.

-- The difference between the highest and lowest patient count is 12 patients,
-- indicating a relatively moderate variation in patient volume among
-- the top 10 hospitals.


--Find the average billing amount for each hospital.
select 
	Hospital,
	ROUND(AVG(Billing_Amount), 2) as [Avg Billing Amount]
from health_care_data
group by Hospital
order by [Avg Billing Amount] desc;

-- Insights:
-------------
-- This analysis identifies the average billing amount for each hospital.

-- Hernez Morton has the highest average billing amount,
-- with approximately $52,373.03.

-- Juarez Clark has the lowest average billing amount,
-- with approximately -$2,008.49.

-- The negative average billing amount for Juarez Clark is an unusual finding
-- and may indicate that refunds or billing adjustments are significantly
-- affecting the hospital's average billing amount.

-- This finding may warrant further investigation into the billing
-- and refund patterns of the hospital.


--Find the hospital with the highest average billing amount.
select top 1
	Hospital,
	ROUND(AVG(Billing_Amount), 2) as [Avg Billing Amount]
from health_care_data
group by Hospital
order by [Avg Billing Amount] desc;

-- Insights:
-------------
-- This analysis identifies the hospital with the highest average billing amount.

-- Hernez Morton has the highest average billing amount,
-- with approximately $52,373.03.


--Calculate each hospital's percentage contribution to total revenue.
select 
	Hospital,
	ROUND(SUM(Billing_Amount), 2) as [Total Revenue],
	ROUND(
		SUM(Billing_Amount) * 100.0 / SUM(SUM(Billing_Amount)) over() 
		, 4
	) as [Percentage Contribution]
from health_care_data
group by Hospital
order by [Total Revenue] desc, [Percentage Contribution] desc;

-- Insights:
-------------
-- Johnson PLC generated the highest total revenue among the hospitals,
-- contributing approximately 0.0765% of the total healthcare network revenue.

-- Medina Elliott Stewart recorded the lowest total revenue,
-- with approximately -$2,633.24, representing a -0.0002% contribution
-- to the overall network revenue.

-- The very small percentage contribution of individual hospitals
-- indicates that the total revenue is distributed across a large number
-- of hospitals in the healthcare network.

-- The negative revenue contribution recorded by Medina Elliott Stewart
-- is unusual and may warrant further investigation into refunds,
-- billing adjustments, or other negative billing transactions.


--Find hospitals whose revenue is above the overall average hospital revenue.
select 
	Hospital,
	ROUND(SUM(Billing_Amount), 2) as [Total Revenue]
from health_care_data
group by Hospital
having SUM(Billing_Amount) > (
						select 
							AVG([Total Revenue])
						from(
							select
								ROUND(SUM(Billing_Amount), 2) as [Total Revenue]
							from health_care_data
							group by Hospital
						) as Hospital_Revenue
						) 
order by [Total Revenue] desc;

-- Insights:
-------------
-- 15,219 hospitals generated revenue above the overall average
-- hospital revenue, indicating that a large number of hospitals
-- performed above the network-wide average.

-- Johnson PLC generated the highest total revenue among the
-- above-average hospitals, with approximately $1.08M.

-- The results highlight considerable variation in revenue
-- performance across hospitals within the healthcare network.

-- The presence of 15,219 above-average hospitals indicates that
-- revenue performance is distributed across a large group of
-- hospitals rather than being concentrated among only a few
-- high-performing hospitals.


--Find the highest and lowest billing amount for each hospital.
select 
	Hospital,
	ROUND(MAX(Billing_Amount),2) as [Max Bill Amount],
	ROUND(MIN(Billing_Amount),2) as [Min Bill Amount]
from health_care_data
group by Hospital;

-- Insights:
-------------
-- Billing amounts varied across hospitals, indicating differences
-- in the size and nature of individual patient bills.

-- Each hospital recorded a different maximum and minimum billing
-- amount, highlighting variation in billing patterns across the network.

-- The presence of very high billing amounts may indicate hospitals
-- handling high-value treatments or patients with more complex
-- healthcare requirements.

-- Negative minimum billing amounts may indicate refunds,
-- billing reversals, or financial adjustments.

-- Comparing maximum and minimum billing amounts helps identify
-- unusual billing patterns and hospitals that may require
-- further investigation.


--5. Medical Condition & Financial Analysis 
----------------------------------------------

--Find the total revenue by medical condition.
select
	Medical_Condition,
	ROUND(SUM(Billing_Amount),2) as [Total Revenue]
from health_care_data
group by Medical_Condition
order by [Total Revenue] desc;

-- Insights:
--------------
-- This analysis identifies the total revenue by medical condition.

-- Diabetes has the highest total revenue,
-- with approximately $238.54M.

-- Cancer has the lowest total revenue,
-- with approximately $232.17M.

-- The difference between the highest and lowest total revenue
-- is approximately $6.37M, indicating that total revenue is
-- relatively balanced across the medical conditions.


--Find the average billing amount by medical condition.
select
	Medical_Condition,
	ROUND(AVG(Billing_Amount),2) as [Average Billing Amount]
from health_care_data
group by Medical_Condition
order by [Average Billing Amount] desc;

-- Insights:
--------------
-- This analysis identifies the average billing amount by medical condition.

-- Obesity has the highest average billing amount,
-- with approximately $25,805.97.

-- Cancer has the lowest average billing amount,
-- with approximately $25,161.79.

-- The difference between the highest and lowest average billing amounts
-- is only $644.18, indicating that the average billing amount is
-- relatively balanced across the medical conditions.

--Find the top 5 medical conditions by revenue.
select
	TOP 5 Medical_Condition,
	ROUND(SUM(Billing_Amount),2) as [Total Revenue]
from health_care_data
group by Medical_Condition
order by [Total Revenue] desc;

-- Insights:
--------------
-- This analysis identifies the top 5 medical conditions by total revenue.

-- Diabetes generates the highest revenue among the top 5 medical conditions,
-- with approximately $238.54M in total revenue.

-- Asthma generates the lowest revenue among the top 5 medical conditions,
-- with approximately $235.46M in total revenue.

-- The revenue difference between the highest and lowest condition in the top 5
-- is relatively small, indicating that revenue is fairly balanced among these conditions.


--Find the medical condition with the highest average billing amount.
select
	TOP 1 Medical_Condition,
	ROUND(AVG(Billing_Amount),2) as [Average Billing Amount]
from health_care_data
group by Medical_Condition
order by [Average Billing Amount] desc;

-- Insights:
--------------
-- This analysis identifies the medical condition with the highest average billing amount,
-- which is Obesity with an average billing amount of $25,805.97.



--Find the percentage contribution of each medical condition to total revenue.
select
	Medical_Condition,
	ROUND(SUM(Billing_Amount),2) as [Total Revenue],
	ROUND(SUM(Billing_Amount) * 100.0 / SUM(SUM(Billing_Amount)) over(),2) as [percentage contribution]
from health_care_data
group by Medical_Condition
order by [Total Revenue] desc;

-- Insights:
--------------
-- This analysis shows the percentage contribution of each medical condition
-- to the total revenue of the healthcare network.

-- Diabetes has the highest revenue contribution at 16.83%,
-- while Cancer has the lowest contribution at 16.38%.

-- The difference between the highest and lowest contribution is only
-- 0.45 percentage points, indicating that revenue is relatively evenly
-- distributed across the medical conditions.

-- No single medical condition dominates the overall revenue contribution,
-- as each condition contributes approximately 16%–17% of total revenue.

-- Business Impact:
-----------------------
-- The relatively balanced revenue contribution suggests that the healthcare
-- network is not heavily dependent on a single medical condition for its revenue.

-- This can help management evaluate resource allocation and capacity planning
-- across medical conditions while considering other factors such as patient
-- volume, treatment requirements, and operational needs.


--Compare medical conditions based on patient count, average billing, and total revenue.
select 
	Medical_Condition,
	COUNT(*) as [Patient Count],
	ROUND(AVG(Billing_Amount),2) as [Average Billing Amount],
	ROUND(SUM(Billing_Amount),2) as [Total Revenue]
from health_care_data
group by Medical_Condition;

-- Insights:
--------------
-- This analysis compares medical conditions based on patient count,
-- average billing amount, and total revenue.

-- Arthritis has the highest patient count with 9,308 patients,
-- indicating the largest patient volume among the medical conditions.

-- Obesity has the highest average billing amount at $25,805.97,
-- indicating the highest average billing amount per patient.

-- Diabetes generates the highest total revenue at approximately $238.54M,
-- followed by Obesity at approximately $238.21M.

-- Cancer has the lowest total revenue among the medical conditions,
-- generating approximately $232.17M.

-- Business Impact:
------------------------
-- This analysis can help the healthcare network understand patient volume,
-- average billing, and revenue contribution across different medical conditions.

-- These insights can support resource allocation, capacity planning,
-- and prioritization of medical services based on patient demand and revenue contribution.


--6. Advanced SQL Analysis 
-----------------------------

--Find the second-highest distinct billing amount.
with ranked_bill_Amount as (
		select 
			DENSE_RANK() over(order by Billing_Amount desc) as [Billing Ranking],
			Billing_Amount
		from health_care_data
) 
select 
	Distinct Billing_Amount
from ranked_bill_Amount
where [Billing Ranking] = 2;

-- Insights:
--------------
-- This analysis identifies the SECOND-highest distinct billing amount in the healthcare network,
-- which is 52,373.03.


--Find the third-highest distinct billing amount.
with ranked_bill_amount as (
		select 
			DENSE_RANK() over(order by Billing_Amount desc) as [Billing Ranking],
			Billing_Amount
		from health_care_data
)
select
	ROUND(Billing_Amount, 2)
from ranked_bill_amount
where [Billing Ranking] = 3;

-- Insights:
--------------
-- This analysis identifies the third-highest distinct billing amount in the healthcare network,
-- which is 52,271.66.


--Rank hospitals by total revenue using RANK() or DENSE_RANK().
select 
	Hospital,
	SUM(Billing_Amount) as [Total Revenue],
	RANK() over(order by SUM(Billing_Amount) desc) as [Hospital Ranking using Rank],
	DENSE_RANK() over(order by SUM(Billing_Amount) desc) as [Hospital Ranking using Dense_Rank]
from health_care_data
group by Hospital;

-- Insights:
--------------
-- This analysis ranks hospitals based on their total revenue using both RANK() and DENSE_RANK().
-- It highlights the difference between RANK() and DENSE_RANK() when hospitals have equal revenue.
-- RANK() assigns the same rank to tied hospitals and skips the subsequent rank, whereas DENSE_RANK() 
-- assigns the same rank without skipping the next rank.


--Find the top 3 hospitals within each admission type based on revenue.
with CTEs as (
	select
		Admission_Type,
		Hospital,
		SUM(Billing_Amount) as [Total Revenue],
		DENSE_RANK() over(partition by Admission_Type order by SUM(Billing_Amount) desc) as [Ranking]
	from health_care_data
	group by Admission_Type, Hospital
)

select 
	Admission_Type,
	Hospital,
	[Total Revenue],
	Ranking
from CTEs 
where [Ranking] in (1,2,3)

-- Insights:
--------------
-- This analysis identifies the top 3 hospitals within each admission type based on total revenue.
-- The results highlight the highest-revenue-performing hospitals across Urgent, Emergency, and Elective admissions.
-- This analysis can help management identify lower-revenue hospitals and investigate the 
-- practices of high-performing hospitals to identify opportunities for improvement.


--Find patients whose billing amount is greater than the average billing amount of their medical condition.
with PatientWithAvg as (
	select
		*,
		AVG(Billing_Amount) over(partition by Medical_Condition) as [Average Billing Amount]
	from health_care_data
)
select *
from PatientWithAvg 
where Billing_Amount > [Average Billing Amount];

-- Insights:
--------------
-- This analysis identifies patients whose billing amount is higher than 
-- the average billing amount for their respective medical condition.


--Calculate a running total of revenue by date.
with DailyRevenue as (
    select
        Date_of_Admission,
        SUM(Billing_Amount) as [Daily Revenue]
    from health_care_data
    group by Date_of_Admission
)
select
    Date_of_Admission,
    [Daily Revenue],
    SUM([Daily Revenue]) over (
        order by Date_of_Admission
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as [Running Total Revenue]
from DailyRevenue
order by Date_of_Admission;

-- Insights:
--------------
-- The healthcare network's cumulative revenue increased progressively throughout the analysis period, 
-- reaching approximately $1.42 billion by the final admission date.


--Calculate year-over-year revenue growth.
with YearlyData as (
	select
		YEAR(Date_of_Admission) as [Year],
		ROUND(SUM(Billing_Amount),2) as [Total Revenue]
	from health_care_data
	group by YEAR(Date_of_Admission)
),
YoY_Calculation as (
	select 
		[Year],
		[Total Revenue],
		ISNULL(
			LAG([Total Revenue],1) over(order by [Year] asc), 
				[Total Revenue]) as [Previous_Year_Revenue]
	from YearlyData
)
select
	[Year], 
	[Total Revenue],
	((([Total Revenue]
	- 
	 [Previous_Year_Revenue]) * 100.0)
	/
	[Previous_Year_Revenue]) as [YOY Revenue Growth %]
from YoY_Calculation

-- Insights:
----------------
-- This analysis shows the year-over-year revenue growth of the healthcare network.

-- 2019 is the first year in the dataset, so YoY revenue growth cannot be
-- calculated due to the absence of prior-year data.

-- Revenue increased by 50.93% in 2020, representing the strongest
-- year-over-year growth during the period.

-- Revenue declined by 2.23% in 2021 compared with the previous year,
-- indicating a moderate contraction after the strong growth in 2020.

-- Revenue increased slightly by 0.33% in 2022, indicating a modest
-- recovery after the decline in 2021.

-- Revenue grew marginally by 0.32% in 2023, indicating relatively
-- stable revenue performance compared with 2022.

-- Revenue declined sharply by 65.31% in 2024, representing the largest
-- year-over-year revenue decrease during the period.

-- Conclusion:
---------------
-- 2020 recorded the strongest YoY revenue growth at 50.93%.

-- 2024 recorded the largest YoY revenue decline at 65.31%.

-- The sharp decline in 2024 warrants further investigation
-- into admission volume, billing amounts, and data coverage
-- to identify the underlying drivers.


--Find the highest-revenue medical condition within each admission type.
with CTEs as (
	select 
		Admission_Type,
		Medical_Condition,
		ROUND(SUM(Billing_Amount),2) as [Total Revenue],
		DENSE_RANK() over(partition by Admission_Type order by SUM(Billing_Amount) desc) as [Ranking]
	from health_care_data
	group by Admission_Type, Medical_Condition
)
select 
	Admission_Type,
	Medical_Condition,
	[Total Revenue],
	Ranking
from CTEs
where [Ranking] = 1;

-- Insights:
-----------------
-- This analysis identifies the highest-revenue medical condition within each admission type.

-- In Elective admissions, Hypertension generates the highest revenue ($82.38M).
-- In Emergency admissions, Obesity generates the highest revenue ($80.69M).
-- In Urgent admissions, Diabetes generates the highest revenue ($82.20M).

-- These findings indicate that different medical conditions are the major
-- revenue contributors within different admission types, suggesting that
-- revenue patterns vary across admission categories.

--Use a CTE to identify hospitals contributing more than 5% of total revenue.
With Hospital_revenue as (
	select 
		Hospital,
		SUM(Billing_Amount) as [Total Revenue],
		(SUM(Billing_Amount) * 100.0) / SUM(SUM(Billing_Amount)) over() as [Percentage Contribution]
	from health_care_data
	group by Hospital
)
select 
	Hospital,
	[Total Revenue],
	[Percentage Contribution]
from Hospital_revenue
where [Percentage Contribution] > 5.0;

-- Insights:
-----------------
-- This analysis identifies hospitals contributing more than 5% of the
-- healthcare network's total revenue.

-- The analysis shows that no individual hospital contributes more than
-- 5% of total network revenue, indicating that revenue is not highly
-- concentrated in a single hospital and is relatively diversified
-- across the network.

--Create a query combining patient count, average billing, total revenue, and revenue contribution % by hospital.
select 
	Hospital,
	count(*) as [Patient Count],
	ROUND(AVG(Billing_Amount),2) as [Average Billing Amount],
	ROUND(SUM(Billing_Amount),2) as [Total Revenue],
	(SUM(Billing_Amount) * 100.0) / SUM(SUM(Billing_Amount)) over() as [Percentage Contribution]
from health_care_data
group by Hospital

-- Insights:
-----------------
-- The analysis compares patient volume, average billing amount, total revenue,
-- and revenue contribution across hospitals within the healthcare network.

-- Hospitals generating higher total revenue are primarily driven by higher patient
-- volume rather than substantially higher average billing per patient, indicating
-- that patient volume is a key driver of overall hospital revenue.


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Project Conclusion:
-------------------------------

-- This analysis provides an overall view of patient demographics,
-- admission patterns, hospital performance, medical conditions,
-- and revenue trends across the healthcare network.

-- The dataset contains 55,500 patient records, with a nearly balanced
-- distribution across genders and admission types.

-- Adults and Senior Citizens represent the largest patient groups,
-- while patient volumes and revenue contributions are relatively
-- evenly distributed across the major medical conditions.

-- Hospital revenue is distributed across a large number of hospitals,
-- with no individual hospital contributing more than 5% of total
-- network revenue.

-- The analysis also identified negative billing amounts, which may
-- represent refunds, billing adjustments, or other financial
-- corrections and warrant further investigation.

-- Revenue increased strongly in 2020 by 50.93%, followed by relatively
-- stable performance from 2021 to 2023. However, revenue declined
-- sharply by 65.31% in 2024, making it an important area for further
-- investigation into admission volume, billing patterns, and data coverage.

-- Overall, the analysis demonstrates how SQL can be used to validate
-- healthcare data, identify important patterns, compare performance,
-- analyze revenue drivers, and generate actionable business insights.
