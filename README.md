# Healthcare SQL Analytics

This repository contains SQL-based healthcare analytics case studies focused on utilization, readmissions, length of stay, and payer mix. The queries are designed to mirror real-world healthcare quality and utilization reporting used by hospitals and managed care organizations.

## Project Focus
- Hospital utilization and discharge trends
- 7-day and 30-day readmission analysis
- Length of stay (LOS) metrics
- Payer mix and utilization patterns
- Identification of high-utilizer patients

## Skills Demonstrated
- Advanced SQL querying (T-SQL style)
- Healthcare quality metric logic (CMS-aligned)
- Conditional aggregation and date-based analysis
- Readmission and utilization rate calculations
- Translating raw data into actionable insights

## Repository Structure

### SQL Case Studies (`/sql`)
- `readmissions_analysis.sql` — Builds 7-day and 30-day readmission flags, calculates overall readmission rates, and ranks conditions by 30-day readmission rate.
- `utilization_metrics.sql` — Core utilization metrics including encounter volume, monthly trends, high-cost encounters, and LOS outliers.
- `payer_mix_analysis.sql` — Payer mix share of total volume, LOS and billing comparisons by payer, high-cost volume by payer, and monthly admissions by payer.
- `high_utilizers.sql` — Identifies high-utilizer patients (frequent encounters) and patients with multiple readmissions.
- `length_of_stay.sql` — LOS summary statistics, LOS by payer, LOS outliers, and monthly LOS trends.

### Documentation
- `README.md` — Project overview and business questions addressed

## Example Business Questions Answered
- What percentage of discharges result in a 30-day readmission?
- Which primary medical conditions have the highest readmission rates?
- How does length of stay vary by condition and payer?
- Which patients account for repeated utilization?
- How does utilization differ across payer types?

## Related Projects
- [Healthcare-EDA](https://github.com/mcqueen17/Healthcare-EDA): Python-based exploratory analysis of hospital readmissions and quality metrics.

## Analytical Continuity

This SQL repository complements the Python-based exploratory analysis in the
[Healthcare-EDA](https://github.com/mcqueen17/Healthcare-EDA) project.

- SQL queries are used to engineer readmission flags and calculate quality metrics
- Python is used for exploratory analysis, visualization, and trend interpretation
- Both projects apply consistent logic to 7-day and 30-day readmission measures

## Notes
These queries are written using synthetic healthcare datasets for demonstration purposes and reflect patterns commonly analyzed in healthcare analytics and quality improvement teams.
