/* =====================================================
   Hospital Readmissions Analysis
   Focus: 7-Day and 30-Day Readmissions
   ===================================================== */

-- View all encounters with a readmission date
SELECT
    encounter_id,
    patient_name,
    date_of_discharge,
    date_of_readmission,
    DATEDIFF(DAY, date_of_discharge, date_of_readmission) AS days_to_readmission
FROM dbo.hospital_readmissions
WHERE date_of_readmission IS NOT NULL;

/* =====================================================
   30-Day Readmission Flag + Overall Readmission Rate
   Notes:
   - readmitted_30_flag = 1 if readmission occurs 0–30 days after discharge
   - NULL readmission dates are treated as not readmitted
   ===================================================== */

-- Add a 30-day readmission flag to each discharge
SELECT
    encounter_id,
    patient_name,
    date_of_discharge,
    date_of_readmission,
    DATEDIFF(DAY, date_of_discharge, date_of_readmission) AS days_to_readmission,
    CASE
        WHEN date_of_readmission IS NOT NULL
             AND DATEDIFF(DAY, date_of_discharge, date_of_readmission) BETWEEN 0 AND 30
        THEN 1
        ELSE 0
    END AS readmitted_30_flag
FROM dbo.hospital_readmissions;

-- Overall 30-day readmission rate (all discharges)
SELECT
    COUNT(*) AS total_discharges,
    SUM(CASE
            WHEN date_of_readmission IS NOT NULL
                 AND DATEDIFF(DAY, date_of_discharge, date_of_readmission) BETWEEN 0 AND 30
            THEN 1
            ELSE 0
        END) AS readmitted_30_days,
    CAST(
        1.0 * SUM(CASE
                    WHEN date_of_readmission IS NOT NULL
                         AND DATEDIFF(DAY, date_of_discharge, date_of_readmission) BETWEEN 0 AND 30
                    THEN 1
                    ELSE 0
                  END) / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,4)
    ) AS readmission_rate_30
FROM dbo.hospital_readmissions
WHERE date_of_discharge IS NOT NULL;

/* =====================================================
   30-Day Readmission Rate by Primary Medical Condition
   ===================================================== */

SELECT
    primary_medical_condition,
    COUNT(*) AS total_discharges,
    SUM(CASE
            WHEN date_of_readmission IS NOT NULL
                 AND DATEDIFF(DAY, date_of_discharge, date_of_readmission) BETWEEN 0 AND 30
            THEN 1
            ELSE 0
        END) AS readmitted_30_days,
    CAST(
        1.0 * SUM(CASE
                    WHEN date_of_readmission IS NOT NULL
                         AND DATEDIFF(DAY, date_of_discharge, date_of_readmission) BETWEEN 0 AND 30
                    THEN 1
                    ELSE 0
                  END) / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,4)
    ) AS readmission_rate_30
FROM dbo.hospital_readmissions
WHERE date_of_discharge IS NOT NULL
GROUP BY primary_medical_condition
HAVING COUNT(*) >= 20
ORDER BY readmission_rate_30 DESC, total_discharges DESC;

/* =====================================================
   7-Day vs 30-Day Readmission Comparison
   ===================================================== */

SELECT
    COUNT(*) AS total_discharges,
    SUM(CASE
            WHEN date_of_readmission IS NOT NULL
                 AND DATEDIFF(DAY, date_of_discharge, date_of_readmission) BETWEEN 0 AND 7
            THEN 1
            ELSE 0
        END) AS readmitted_7_days,
    SUM(CASE
            WHEN date_of_readmission IS NOT NULL
                 AND DATEDIFF(DAY, date_of_discharge, date_of_readmission) BETWEEN 0 AND 30
            THEN 1
            ELSE 0
        END) AS readmitted_30_days,
    CAST(
        1.0 * SUM(CASE
                    WHEN date_of_readmission IS NOT NULL
                         AND DATEDIFF(DAY, date_of_discharge, date_of_readmission) BETWEEN 0 AND 7
                    THEN 1
                    ELSE 0
                  END) / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,4)
    ) AS readmission_rate_7,
    CAST(
        1.0 * SUM(CASE
                    WHEN date_of_readmission IS NOT NULL
                         AND DATEDIFF(DAY, date_of_discharge, date_of_readmission) BETWEEN 0 AND 30
                    THEN 1
                    ELSE 0
                  END) / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,4)
    ) AS readmission_rate_30
FROM dbo.hospital_readmissions
WHERE date_of_discharge IS NOT NULL;
