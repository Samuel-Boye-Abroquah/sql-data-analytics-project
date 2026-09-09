-- =============================================================================
-- Performance Analysis (Year-over-Year)
-- Data Warehouse Project (Gold Layer)
--
-- Purpose: analyze each product's yearly performance against (a) its own
-- historical average and (b) its previous year's sales \u2014 answers "is this
-- product trending up or down" rather than just "how much did it sell."
--
-- KNOWN LIMITATION: dim_products is filtered to current product versions
-- only (prd_end_dt IS NULL). Historical sales tied to a superseded product
-- version will not resolve to a product_name here. See ranking analysis
-- file for the same note in more detail.
--
-- IMPROVEMENT APPLIED: grouped/partitioned by product_key, not product_name.
-- =============================================================================

WITH cte_current_sales AS (
    SELECT
        p.product_key,
        p.product_name,
        YEAR(f.order_date) AS order_year,
        SUM(f.sales) AS current_sales
    FROM fact_sales f
    LEFT JOIN dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY p.product_key, p.product_name, order_year
),
cte_prev AS (
    SELECT
        *,
        LAG(current_sales) OVER (PARTITION BY product_key ORDER BY order_year) AS previous_year_sales
    FROM cte_current_sales
)
SELECT
    product_name,
    order_year,
    current_sales,
    previous_year_sales,
    AVG(current_sales) OVER (PARTITION BY product_key) AS avg_sales,
    current_sales - AVG(current_sales) OVER (PARTITION BY product_key) AS current_to_avg,
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_key) > 0 THEN 'Above avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_key) < 0 THEN 'Below avg'
        ELSE 'Tie'
    END AS average_change,
    current_sales - previous_year_sales AS yoy_change_value,
    CASE
        WHEN current_sales - previous_year_sales > 0 THEN 'Increase'
        WHEN current_sales - previous_year_sales < 0 THEN 'Decrease'
        ELSE 'No change'
    END AS yoy_change
FROM cte_prev
ORDER BY product_name, order_year;
