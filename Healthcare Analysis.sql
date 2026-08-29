-- 🏥 Healthcare SQL Analysis
--------------------------------------

--📌 Insight Formula

-- What happened → How much → Why/Where → So what (business impact)

------------------------------------------------------------------------

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

--Find the total revenue by admission type.
select 
	Admission_Type,
	ROUND(SUM(Billing_Amount), 2) as [Total Revenue]
from health_care_data
group by Admission_Type
order by [Total Revenue] desc;

--Identify the admission type generating the highest revenue.
select 
	top 1 Admission_Type,
	ROUND(SUM(Billing_Amount), 2) as [Total Revenue]
from health_care_data
group by Admission_Type
order by [Total Revenue] desc;


--Analyze admissions by year and month.
select 
	Admission_Type,
	FORMAT(Date_of_Admission, 'yyyy-MM') as [Year-Month],
	count(*) as [Total Admission]
from health_care_data
group by Admission_Type,
		 FORMAT(Date_of_Admission, 'yyyy-MM')
order by [Year-Month] asc;



--Find the month/year with the highest number of admissions.
select 
	top 1
	FORMAT(Date_of_Admission, 'yyyy-MM') as [Year-Month],
	count(*) as [Total Admission]
from health_care_data
group by 
		 FORMAT(Date_of_Admission, 'yyyy-MM')
order by [Total Admission] desc;


--4. Hospital & Revenue Analysis 
--------------------------------------

--Find the total revenue generated by each hospital.
select 
	Hospital,
	SUM(Billing_Amount) as [Total Revenue]
from health_care_data
group by Hospital
order by [Total Revenue] desc;

--Find the top 10 hospitals by revenue.
select top 10
	Hospital,
	SUM(Billing_Amount) as [Total Revenue]
from health_care_data
group by Hospital
order by [Total Revenue] desc;

--Find the top 10 hospitals by patient count.
select top 10
	Hospital,
	COUNT(*) as [Total Patients]
from health_care_data
group by Hospital
order by [Total Patients] desc;


--Find the average billing amount for each hospital.
select 
	Hospital,
	ROUND(AVG(Billing_Amount), 2) as [Avg Billing Amount]
from health_care_data
group by Hospital
order by [Avg Billing Amount] desc;

--Find the hospital with the highest average billing amount.
select top 1
	Hospital,
	ROUND(AVG(Billing_Amount), 2) as [Avg Billing Amount]
from health_care_data
group by Hospital
order by [Avg Billing Amount] desc;

--Calculate each hospital's percentage contribution to total revenue.
select 
	Hospital,
	ROUND(SUM(Billing_Amount), 2) as [Total Revenue],
	ROUND(
		SUM(Billing_Amount) * 100.0 / SUM(SUM(Billing_Amount)) over() 
		, 2
	) as [Percentage Contribution]
from health_care_data
group by Hospital
order by [Total Revenue] desc, [Percentage Contribution] desc;

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

-- Query optimise through CTEs pending...


--Find the highest and lowest billing amount for each hospital.



--5. Medical Condition & Financial Analysis 
----------------------------------------------

--Find the total revenue by medical condition.
--Find the average billing amount by medical condition.
--Find the top 5 medical conditions by revenue.
--Find the medical condition with the highest average billing amount.
--Find the percentage contribution of each medical condition to total revenue.
--Compare medical conditions based on patient count, average billing, and total revenue.


--6. Advanced SQL Analysis 
-----------------------------

--Find the second-highest distinct billing amount.
--Find the third-highest distinct billing amount.
--Rank hospitals by total revenue using RANK() or DENSE_RANK().
--Find the top 3 hospitals within each admission type based on revenue.
--Find patients whose billing amount is greater than the average billing amount of their medical condition.
--Calculate a running total of revenue by date.
--Calculate year-over-year revenue growth.
--Find the highest-revenue medical condition within each admission type.
--Use a CTE to identify hospitals contributing more than 5% of total revenue.
--Create a query combining patient count, average billing, total revenue, and revenue contribution % by hospital.