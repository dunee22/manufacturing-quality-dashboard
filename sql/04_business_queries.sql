
-- 1. Total defective units by production line
-- Business question:
-- Which production line generated the highest number of defective units?
-- Insight:
-- Line 2 has the highest total defective units

SELECT  
    pl.line_name AS line_name,
    SUM(pr.defective_units) AS total_defective_units
FROM production_records AS pr
JOIN production_lines AS pl
    ON pr.production_line_id = pl.production_line_id
GROUP BY pl.production_line_id, pl.line_name
ORDER BY total_defective_units DESC;



-- 2. Defect rate by production line
-- Business question:
-- Which production line has the highest defect rate?
-- Insight:
-- Line 4 has the highest defect rate, while Line 2 has the highest total defective units.

SELECT  
    pl.line_name AS line_name,
    SUM(pr.produced_units) AS total_produced_units,
    SUM(pr.defective_units) AS total_defective_units,
    ROUND(
        SUM(pr.defective_units) * 100.0 / SUM(pr.produced_units),
        2
    ) AS defect_rate_percent
FROM production_records AS pr
JOIN production_lines AS pl
    ON pr.production_line_id = pl.production_line_id
GROUP BY pl.production_line_id, pl.line_name
ORDER BY defect_rate_percent DESC;


-- 3. Total downtime by production line
-- Business question:
-- Which production line has the highest accumulated downtime?
-- Line 3 with 5002 minutes in total

SELECT  
    pl.line_name AS line_name,
    SUM(pr.downtime_minutes) AS total_downtime_minutes
FROM production_records AS pr
JOIN production_lines AS pl
    ON pr.production_line_id = pl.production_line_id
GROUP BY pl.production_line_id, pl.line_name
ORDER BY total_downtime_minutes DESC;


-- 4. Production, defects, defect rate and downtime by shift
-- Business question:
-- Which shift has the worst quality and operational performance?
-- Insight:
-- Night shift has the highest defect rate and downtime, while Morning shift performs best.

SELECT
    sh.shift_name AS shift_name,
    SUM(pr.produced_units) AS total_produced_units,
    SUM(pr.defective_units) AS total_defective_units,
    ROUND(
        SUM(pr.defective_units) * 100.0 / SUM(pr.produced_units),
        2
    ) AS defect_rate_percent,
    SUM(pr.downtime_minutes) AS total_downtime_minutes
FROM production_records AS pr
JOIN shifts AS sh
    ON pr.shift_id = sh.shift_id
GROUP BY sh.shift_id, sh.shift_name
ORDER BY defect_rate_percent DESC;


-- 5. Production, defects, defect rate and downtime by product
-- Business question:
-- Which product has the worst quality performance?
-- Insight:
-- Refrigerator Control Board has the highest defect rate among products.

SELECT
    pd.product_name AS product_name,
    pd.appliance_type AS appliance_type,
    SUM(pr.produced_units) AS total_produced_units,
    SUM(pr.defective_units) AS total_defective_units,
    ROUND(
        SUM(pr.defective_units) * 100.0 / SUM(pr.produced_units),
        2
    ) AS defect_rate_percent,
    SUM(pr.downtime_minutes) AS total_downtime_minutes
FROM production_records AS pr
JOIN products AS pd
    ON pr.product_id = pd.product_id
GROUP BY pd.product_id, pd.product_name, pd.appliance_type
ORDER BY defect_rate_percent DESC;


-- 6. Total defects by defect type
-- Business question:
-- What are the most frequent defect types?
-- Insight:
-- Defective soldering is the most frequent defect type, with 4,583 recorded defects.
-- This suggests that the soldering process should be reviewed as a priority area
-- for quality improvement in the simulated production environment.

SELECT  
    dt.defect_name AS defect_name,
    SUM(dr.defect_quantity) AS total_defect_units
FROM defect_records AS dr
JOIN defect_types AS dt
    ON dr.defect_type_id = dt.defect_type_id
GROUP BY dt.defect_type_id, dt.defect_name
ORDER BY total_defect_units DESC;


-- 7. Defect types by product
-- Business question:
-- Which defect types are most frequent for each product?
-- Insight:
-- Defective soldering is the top issue for Washing Machine Control Board.
-- Programming error is the top issue for Refrigerator Control Board.
-- Oven Control Board shows relevant issues in both defective soldering and physical damage.

SELECT  
    pd.product_name AS product_name,
    dt.defect_name AS defect_name,    
    SUM(dr.defect_quantity) AS total_defect_units
FROM defect_records AS dr
JOIN defect_types AS dt
    ON dr.defect_type_id = dt.defect_type_id
JOIN production_records AS pr
    ON dr.production_record_id = pr.production_record_id
JOIN products AS pd
    ON pr.product_id = pd.product_id
GROUP BY 
    pd.product_id,
    pd.product_name,
    dt.defect_type_id,
    dt.defect_name
ORDER BY total_defect_units DESC;


-- 8. Daily production, defect rate and downtime
-- Business question:
-- Which days had the worst defect rate and highest downtime?
-- Insight:
-- 2026-06-12 had the highest daily defect rate at 4.65%.

SELECT  
    pr.production_date AS production_date,
    SUM(pr.produced_units) AS total_produced_units,
    SUM(pr.defective_units) AS total_defective_units,
    ROUND(
        SUM(pr.defective_units) * 100.0 / SUM(pr.produced_units),
        2
    ) AS defect_rate_percent,
    SUM(pr.downtime_minutes) AS total_downtime_minutes
FROM production_records AS pr
GROUP BY pr.production_date
ORDER BY defect_rate_percent DESC;


-- 9. Daily downtime and defect rate
-- Business question:
-- Do days with higher downtime also show higher defect rates?
-- Insight:
-- 2026-06-27 had the highest downtime with 562 minutes, but it did not have
-- the highest defect rate. This suggests that downtime may be related to quality
-- issues, but it is not the only factor explaining defect rates.

SELECT  
    pr.production_date AS production_date,
    SUM(pr.defective_units) AS total_defective_units,
    SUM(pr.downtime_minutes) AS total_downtime_minutes,
    ROUND(
        SUM(pr.defective_units) * 100.0 / SUM(pr.produced_units),
        2
    ) AS defect_rate_percent
FROM production_records AS pr
GROUP BY pr.production_date
ORDER BY total_downtime_minutes DESC;


-- 10. Overall production KPIs
-- Business question:
-- What are the main overall production and quality KPIs?
-- Insight:
-- The simulated production dataset contains 338 production records,
-- 295,163 produced units, 12,667 defective units, an overall defect rate
-- of 4.29%, and 14,635 total downtime minutes.
-- These KPIs can be used as the main summary cards in the Power BI dashboard.

SELECT
    SUM(pr.produced_units) AS total_produced_units,
    SUM(pr.defective_units) AS total_defective_units,
    ROUND(
        SUM(pr.defective_units) * 100.0 / SUM(pr.produced_units),
        2
    ) AS overall_defect_rate_percent,
    SUM(pr.downtime_minutes) AS total_downtime_minutes,
    COUNT(pr.production_record_id) AS total_production_records
FROM production_records AS pr;