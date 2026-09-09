-- =============================================================================
-- Part-to-Whole Analysis
-- Data Warehouse Project (Gold Layer)
--
-- Purpose: what share of the total does each slice represent \u2014 complements
-- magnitude analysis (raw totals) with proportion, which is often the more
-- useful number for a business audience ("category X is 42% of revenue"
-- lands better than a raw dollar figure alone).
--
-- KNOWN LIMITATION: the category and product-line breakdowns join
-- dim_products, which is filtered to current product versions only
-- (prd_end_dt IS NULL). See ranking analysis file for detail.
-- =============================================================================

-- % of total revenue by product category
SELECT
    p.category,
    SUM(f.sales) AS category_revenue,
    ROUND(SUM(f.sales) * 100.0 / SUM(SUM(f.sales)) OVER (), 2) AS pct_of_total_revenue
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY category_revenue DESC;

-- % of total revenue by country
SELECT
    c.country,
    SUM(f.sales) AS country_revenue,
    ROUND(SUM(f.sales) * 100.0 / SUM(SUM(f.sales)) OVER (), 2) AS pct_of_total_revenue
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY country_revenue DESC;

-- % of total customers by gender
SELECT
    gender,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total_customers
FROM dim_customers
GROUP BY gender
ORDER BY customer_count DESC;
