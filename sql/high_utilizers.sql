/* =====================================================
   Payer Mix & Utilization Patterns
   Dataset: dbo.encounters_practice
   ===================================================== */

---------------------------------------------------------
-- 1) Payer mix: encounters + share of total
---------------------------------------------------------
WITH payer_counts AS (
    SELECT
        payor,
        COUNT(*) AS encounter_count
    FROM dbo.encounters_practice
    WHERE payor IS NOT NULL
    GROUP BY payor
),
total AS (
    SELECT SUM(encounter_count) AS total_encounters
    FROM payer_counts
)
SELECT
    pc.payor,
    pc.encounter_count,
    CAST(100.0 * pc.encounter_count / NULLIF(t.total_encounters, 0) AS DECIMAL(10,2)) AS pct_of_total
FROM payer_counts pc
CROSS JOIN total t
ORDER BY pc.encounter_count DESC;

---------------------------------------------------------
-- 2) Average LOS and average billing by payer
---------------------------------------------------------
SELECT
    payor,
    CAST(AVG(CAST(length_of_stay_days AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS avg_los_days,
    CAST(AVG(CAST(billing_amount AS DECIMAL(12,2))) AS DECIMAL(12,2)) AS avg_billing_amount
FROM dbo.encounters_practice
WHERE payor IS NOT NULL
GROUP BY payor
ORDER BY avg_los_days DESC;

---------------------------------------------------------
-- 3) High-cost encounters by payer (threshold example)
---------------------------------------------------------
SELECT
    payor,
    COUNT(*) AS high_cost_encounters
FROM dbo.encounters_practice
WHERE payor IS NOT NULL
  AND billing_amount > 10000
GROUP BY payor
ORDER BY high_cost_encounters DESC;

---------------------------------------------------------
-- 4) Monthly admissions by payer (trend)
---------------------------------------------------------
SELECT
    DATEFROMPARTS(YEAR(date_of_admission), MONTH(date_of_admission), 1) AS admission_month,
    payor,
    COUNT(*) AS admissions
FROM dbo.encounters_practice
WHERE date_of_admission IS NOT NULL
  AND payor IS NOT NULL
GROUP BY DATEFROMPARTS(YEAR(date_of_admission), MONTH(date_of_admission), 1), payor
ORDER BY admission_month, admissions DESC;

