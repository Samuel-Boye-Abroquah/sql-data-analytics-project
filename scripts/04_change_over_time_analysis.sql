-- =============================================================================
-- Change Over Time Analysis
-- Data Warehouse Project (Gold Layer)
--
-- Purpose: yearly and monthly trends in sales, active customers, and quantity
-- sold. Foundation for the cumulative and YoY performance analysis that
-- follows in later files.
-- =============================================================================

-- Yearly trend
SELECT
    YEAR(order_date) AS order_year,
    SUM(sales) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY order_year;

-- Monthly trend (year + month)
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year, order_month
ORDER BY order_year, order_month;
