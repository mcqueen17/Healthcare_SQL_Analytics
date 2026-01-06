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

