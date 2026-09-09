-- =============================================================================
-- Ranking Analysis
-- Data Warehouse Project (Gold Layer)
--
-- Purpose: top/bottom performers by revenue and order count.
--
-- KNOWN LIMITATION (applies to every query in this file that joins
-- dim_products): dim_products is filtered to current product versions only
-- (prd_end_dt IS NULL in the gold view). Sales tied to a superseded product
-- version will not resolve to a product_name here, which can silently
-- understate a product's true ranking. Revisit the dim_products view if
-- historical product versions need to be included in rankings.
--
-- IMPROVEMENT APPLIED: rankings group by product_key (the stable surrogate),
-- not product_name (text) \u2014 avoids the same class of risk as grouping by a
-- mutable/non-guaranteed-unique text field.
-- =============================================================================

-- Top 5 selling products by revenue
SELECT
    p.product_name,
    SUM(f.sales) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.product_key, p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Bottom 5 selling products by revenue
SELECT
    p.product_name,
    SUM(f.sales) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.product_key, p.product_name
ORDER BY total_revenue ASC
LIMIT 5;

-- Top 10 customers by revenue
SELECT
    c.customer_key,
    c.first_name,
    SUM(f.sales) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Top 3 customers with the FEWEST distinct orders
-- FIXED: original used COUNT(order_number), which counts line items, not
-- orders \u2014 since fact_sales is at line-item grain, a single order with 5
-- products would have inflated this count 5x. COUNT(DISTINCT order_number)
-- is the correct measure of "number of orders."
SELECT
    c.customer_key,
    c.first_name,
    COUNT(DISTINCT f.order_number) AS total_orders
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name
ORDER BY total_orders ASC
LIMIT 3;
