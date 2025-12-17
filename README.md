# Cleaning Operations Reporting Automation

This repository contains a BigQuery SQL query used to automate the reporting of staff load balancing for cleaning operations. The solution facilitates integrating Google Sheets as the data source, utilizes BigQuery for orchestration and data transformation, and visualizes the data through Looker Studio.

## Project Overview

The primary aim of this project is to provide automated, accurate, and easily interpretable reporting for cleaning operations. By leveraging Google Sheets, BigQuery, and Looker Studio, we ensure a seamless data pipeline from data entry to meaningful visualization.

### Features:
- Integration with Google Sheets as the raw data source.
- Use of BigQuery to process and calculate staff workload using advanced SQL logic (window functions, case logic).
- Visual representation of workload in Looker Studio, implementing an easy-to-understand 'Traffic Light' system.
- Fully automated setup using BigQuery scheduled queries.

## Architecture Diagram (Description)

The architecture of the system involves the following steps:
1. **Source:** Data is entered manually or uploaded into Google Sheets.
2. **BigQuery:** Scheduled queries are triggered to fetch, clean, and transform the data.
3. **Logic:** SQL logic calculates workload status (Overloaded, Perfect Load, Underutilized) using window functions and case conditions.
4. **Visualization:** Looker Studio connects to BigQuery to display results in an intuitive dashboard.

This setup ensures reliable data flow with minimal manual intervention.

## SQL Logic

The key logic in the SQL script determines staff workload status based on the following **'Traffic Light' system**:

1. **Overloaded**: If the assigned shift's load is higher than the threshold.
   - **Indicator:** Red
2. **Perfect Load**: An optimal staff-to-shift workload ratio with no overloading or underutilization.
   - **Indicator:** Green
3. **Underutilized**: When the assigned shift's load is below the efficiency threshold.
   - **Indicator:** Yellow

The script uses BigQuery window functions and case logic to compute these categories efficiently across datasets. This enables the aggregation of insights for large sets of employee workload data.

## Setup Instructions

Follow these steps to deploy the solution:

1. **Google Sheets Setup:**
   - Create a Google Sheet to act as the data source.
   - Ensure it contains fields such as `Shift ID`, `Employee Name`, `Assigned Load`, and `Shift Date`.

2. **BigQuery Configuration:**
   - Import your Google Sheets data into BigQuery.
   - Create a dataset in BigQuery to store cleaned data.
   - Upload the SQL query from this repository into a new scheduled query in BigQuery.

3. **Logic Testing:**
   - Execute the query manually at least once to validate data transformations.
   - Debug any discrepancies in data or logic.

4. **Looker Studio Integration:**
   - Link Looker Studio to your BigQuery account.
   - Design and publish a dashboard to display calculated metrics using the 'Traffic Light' indicators. 

5. **Automation:**
   - Schedule the BigQuery query to run at desired intervals (e.g., daily) to ensure reports stay up-to-date.

---

### Contribution
Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

### License
This project is licensed under the [MIT License](LICENSE).

### Acknowledgments
Special thanks to the cleaning operations team and the data analysts for providing insights on workforce optimization.