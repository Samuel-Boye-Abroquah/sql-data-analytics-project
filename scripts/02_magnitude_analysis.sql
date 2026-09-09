-- =============================================================================
-- Magnitude Analysis
-- Data Warehouse Project (Gold Layer)
--
-- Purpose: headline totals and "how much / how many" breakdowns by dimension
-- (country, gender, category) \u2014 the size and shape of the business.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Headline measures
-- -----------------------------------------------------------------------------
SELECT SUM(sales) AS total_sales FROM fact_sales;
SELECT SUM(quantity) AS total_quantity FROM fact_sales;
SELECT AVG(price) AS avg_selling_price FROM fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM fact_sales;
SELECT COUNT(product_key) AS total_products FROM dim_products;
SELECT COUNT(customer_key) AS total_customers FROM dim_customers;

-- Customers who have placed at least one order.
-- Two equivalent approaches \u2014 both shown since either is a fine pattern to know.
SELECT COUNT(DISTINCT d.customer_key) AS customers_with_orders
FROM fact_sales f
JOIN dim_customers d ON f.customer_key = d.customer_key;

SELECT COUNT(DISTINCT customer_key) AS customers_with_orders
FROM dim_customers
WHERE customer_key IN (SELECT DISTINCT customer_key FROM fact_sales);

-- -----------------------------------------------------------------------------
-- Snapshot of all headline measures in one result set
-- -----------------------------------------------------------------------------
SELECT 'Total Sales' AS measure, SUM(sales) AS value FROM fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM fact_sales
UNION ALL
SELECT 'Total Products', COUNT(product_key) FROM dim_products
UNION ALL
SELECT 'Customers With Orders', COUNT(DISTINCT customer_key) FROM dim_customers;

-- -----------------------------------------------------------------------------
-- Breakdowns by dimension
-- -----------------------------------------------------------------------------

-- Total customers by country
SELECT country, COUNT(*) AS total_customers
FROM dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Total customers by gender
SELECT gender, COUNT(*) AS total_customers
FROM dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Total products by category
SELECT category, COUNT(*) AS total_products
FROM dim_products
GROUP BY category;

-- Average cost by category
SELECT category, ROUND(AVG(cost_price), 2) AS average_cost
FROM dim_products
GROUP BY category
ORDER BY average_cost DESC;

-- Total revenue by customer
-- NOTE: LEFT JOIN kept intentionally \u2014 a customer with no sales still appears
-- with a NULL/0 total rather than being silently dropped.
SELECT
    c.customer_key,
    c.first_name,
    SUM(f.sales) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name
ORDER BY total_revenue DESC;

-- Total revenue by category
-- KNOWN LIMITATION: dim_products is filtered to current product versions only
-- (prd_end_dt IS NULL in the gold view). Sales tied to a superseded product
-- version will show a NULL category here. Revisit the dim_products view if
-- historical categorization needs to be preserved.
SELECT
    p.category,
    SUM(f.sales) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_products p ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Total quantity sold by country
SELECT
    c.country,
    SUM(f.quantity) AS quantities_sold
FROM fact_sales f
LEFT JOIN dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY quantities_sold DESC;
