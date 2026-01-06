/* =====================================================
   Length of Stay (LOS) Analysis
   Dataset: dbo.encounters_practice
   ===================================================== */

---------------------------------------------------------
-- 1) Overall LOS summary
---------------------------------------------------------
SELECT
    COUNT(*) AS total_encounters,
    CAST(AVG(CAST(length_of_stay_days AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_los_days,
    MIN(length_of_stay_days) AS min_los_days,
    MAX(length_of_stay_days) AS max_los_days
FROM dbo.encounters_practice
WHERE length_of_stay_days IS NOT NULL;

---------------------------------------------------------
-- 2) Average LOS by payer
---------------------------------------------------------
SELECT
    payor,
    COUNT(*) AS encounter_count,
    CAST(AVG(CAST(length_of_stay_days AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_los_days
FROM dbo.encounters_practice
WHERE length_of_stay_days IS NOT NULL
  AND payor IS NOT NULL
GROUP BY payor
ORDER BY avg_los_days DESC;

---------------------------------------------------------
-- 3) Highest LOS encounters (outliers)
---------------------------------------------------------
SELECT TOP 15
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

---------------------------------------------------------
-- 4) LOS trend over time (monthly average LOS)
---------------------------------------------------------
SELECT
    DATEFROMPARTS(YEAR(date_of_admission), MONTH(date_of_admission), 1) AS admission_month,
    CAST(AVG(CAST(length_of_stay_days AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_los_days
FROM dbo.encounters_practice
WHERE date_of_admission IS NOT NULL
  AND length_of_stay_days IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(date_of_admission), MONTH(date_of_admission), 1)
ORDER BY admission_month;

