/* FILENAME: staff_load_analysis.sql
   DESCRIPTION: Analyzes daily staff workload to identify overloaded shifts.
   NOTE: Table names and IDs have been sanitized for confidentiality.
*/

WITH DailyProductivity AS (
    SELECT
      EXTRACT(YEAR FROM t.Date) AS cleaning_year,
      EXTRACT(QUARTER FROM t.Date) AS cleaning_quarter,
      t.Date AS cleaning_day,
      COUNT(DISTINCT t.order_id) AS orders_per_day,   -- Renamed from specific ID for clarity
      COUNT(DISTINCT t.staff_id) AS staff_per_day     -- Renamed from specific ID for clarity
    FROM `your_project_id.operations_dataset.daily_cleaning_logs` AS t -- SANITIZED
    WHERE t.property_id IS NOT NULL 
    GROUP BY cleaning_year, cleaning_quarter, cleaning_day
  )

SELECT
  dp.cleaning_year,
  dp.cleaning_quarter,
  dp.cleaning_day AS date,
  dp.orders_per_day,
  dp.staff_per_day,
  
  -- 1. Load Calculation
  ROUND(SAFE_DIVIDE(dp.orders_per_day, dp.staff_per_day), 2) AS load_per_staff,
  
  -- 2. Status Logic (The "Traffic Light" System)
  CASE
    WHEN dp.staff_per_day = 0 THEN 'Error: No Staff'
    WHEN SAFE_DIVIDE(dp.orders_per_day, dp.staff_per_day) > 3 THEN 'Overloaded'
    WHEN MOD(dp.orders_per_day, dp.staff_per_day) = 0 
         AND SAFE_DIVIDE(dp.orders_per_day, dp.staff_per_day) >= 2 THEN 'Perfect Load'
    WHEN MOD(dp.orders_per_day, dp.staff_per_day) = 0 
         AND SAFE_DIVIDE(dp.orders_per_day, dp.staff_per_day) < 2 THEN 'Underutilized'
    ELSE 'Unbalanced'
  END AS operational_status,
  
  -- 3. Roster Context
  CASE
    WHEN dp.staff_per_day = 0 THEN 'Cannot determine roster details with no staff'
    WHEN MOD(dp.orders_per_day, dp.staff_per_day) != 0 THEN
        FORMAT(
          '%d staff do %d, %d staff do %d',
          dp.staff_per_day - MOD(dp.orders_per_day, dp.staff_per_day),
          DIV(dp.orders_per_day, dp.staff_per_day),
          MOD(dp.orders_per_day, dp.staff_per_day),
          DIV(dp.orders_per_day, dp.staff_per_day) + 1
        )
    ELSE 'Everyone does equal work'
  END AS roster_details

FROM DailyProductivity AS dp
ORDER BY dp.cleaning_year, dp.cleaning_quarter, dp.cleaning_day;
