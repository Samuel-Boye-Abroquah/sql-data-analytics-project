-- =============================================================================
-- Exploratory Data Analysis
-- Data Warehouse Project (Gold Layer)
--
-- Purpose: first-pass exploration of the Gold layer \u2014 date ranges, customer
-- demographics, and distinct values \u2014 to understand the shape of the data
-- before building magnitude, ranking, and trend analysis on top of it.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Order date range in fact_sales
-- -----------------------------------------------------------------------------
SELECT
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_month_range
FROM fact_sales;

-- -----------------------------------------------------------------------------
-- Customer age range (dim_customers)
-- MIN(birth_date) is the earliest birth date -> the OLDEST customer.
-- MAX(birth_date) is the most recent birth date -> the YOUNGEST customer.
-- -----------------------------------------------------------------------------
SELECT
    MAX(birth_date) AS youngest_birth_date,
    MIN(birth_date) AS oldest_birth_date,
    TIMESTAMPDIFF(YEAR, MIN(birth_date), CURDATE()) AS oldest_age,
    TIMESTAMPDIFF(YEAR, MAX(birth_date), CURDATE()) AS youngest_age
FROM dim_customers;

-- -----------------------------------------------------------------------------
-- Distinct values \u2014 useful for spotting inconsistent codes early
-- -----------------------------------------------------------------------------
SELECT DISTINCT country FROM dim_customers;
SELECT DISTINCT gender FROM dim_customers;
SELECT DISTINCT marital_status FROM dim_customers;
