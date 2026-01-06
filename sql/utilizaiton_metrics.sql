/* =====================================================
   Utilization & Financial Metrics
   Dataset: dbo.encounters_practice (example)
   ===================================================== */

---------------------------------------------------------
-- 1) Basic utilization: total encounters
---------------------------------------------------------
SELECT
    COUNT(*) AS total_encounters
FROM dbo.encounters_practice;

---------------------------------------------------------
-- 2) Encounters by payer (payer mix / utilization)
---------------------------------------------------------
SELECT
    payor,
    COUNT(*) AS encounter_count
FROM dbo.encounters_practice
GROUP BY payor
ORDER BY encounter_count DESC;

---------------------------------------------------------
-- 3) Average length of stay by payer
---------------------------------------------------------
SELECT
    payor,
    CAST(AVG(CAST(length_of_stay_days AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_length_of_stay_days
FROM dbo.encounters_practice
WHERE length_of_stay_days IS NOT NULL
GROUP BY payor
ORDER BY avg_length_of_stay_days DESC;

---------------------------------------------------------
-- 4) High-cost encounters (example threshold: $10,000)
---------------------------------------------------------
SELECT
    patient_id,
    patient_name,
    payor,
    billing_amount,
    length_of_stay_days,
    date_of_admission,
    date_of_discharge
FROM dbo.encounters_practice
WHERE billing_amount > 10000
ORDER BY billing_amount DESC;

---------------------------------------------------------
-- 5) Monthly admissions trend
-- Tip: using DATEFROMPARTS to safely group by month in T-SQL
---------------------------------------------------------
SELECT
    DATEFROMPARTS(YEAR(date_of_admission), MONTH(date_of_admission), 1) AS admission_month,
    COUNT(*) AS admissions
FROM dbo.encounters_practice
WHERE date_of_admission IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(date_of_admission), MONTH(date_of_admission), 1)
ORDER BY admission_month;

---------------------------------------------------------
-- 6) Monthly average LOS trend
---------------------------------------------------------
SELECT
    DATEFROMPARTS(YEAR(date_of_admission), MONTH(date_of_admission), 1) AS admission_month,
    CAST(AVG(CAST(length_of_stay_days AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_los_days
FROM dbo.encounters_practice
WHERE date_of_admission IS NOT NULL
  AND length_of_stay_days IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(date_of_admission), MONTH(date_of_admission), 1)
ORDER BY admission_month;

---------------------------------------------------------
-- 7) Top 10 highest LOS encounters (utilization outliers)
---------------------------------------------------------
SELECT TOP 10
    patient_id,
    patient_name,
    payor,
    length_of_stay_days,
    billing_amount,
    date_of_admission,
    date_of_discharge
FROM dbo.encounters_practice
WHERE length_of_stay_days IS NOT NULL
ORDER BY length_of_stay_days DESC, billing_amount DESC;
