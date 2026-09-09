-- =============================================================================
-- Cumulative Analysis
-- Data Warehouse Project (Gold Layer)
--
-- Purpose: running totals over time \u2014 shows growth trajectory rather than
-- isolated period-by-period figures.
-- =============================================================================

-- Running total of sales, month over month
SELECT
    *,
    SUM(total_sales) OVER (ORDER BY month_year) AS running_total_sales
FROM (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month_year,
        SUM(sales) AS total_sales
    FROM fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY month_year
) t
ORDER BY month_year;
