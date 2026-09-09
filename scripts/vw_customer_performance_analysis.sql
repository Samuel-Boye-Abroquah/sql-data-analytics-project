/*
===============================================================================
VIEW: vw_customer_performance_analysis
===============================================================================

PURPOSE
    This report provides a customer-centric view of sales performance by
    consolidating customer demographics, purchasing behavior, and key
    business metrics.

BUSINESS OBJECTIVES
    - Identify high-value customers
    - Measure customer engagement and loyalty
    - Analyze customer purchasing behavior
    - Support customer segmentation strategies
    - Monitor sales contributions across customer groups

KEY METRICS
    - Total Orders
    - Total Sales
    - Total Quantity Purchased
    - Total Products Purchased
    - Customer Lifespan (Months)
    - Average Order Value (AOV)
    - Average Monthly Spend
    - Recency (Last Purchase Date)

CUSTOMER SEGMENTS
    VIP:
        Revenue > 5,000 and lifespan >= 12 months

    Regular:
        Revenue <= 5,000 and lifespan >= 12 months

    New:
        All remaining customers

===============================================================================
*/

CREATE OR REPLACE VIEW vw_customer_performance_analysis AS

WITH customer_base AS (

    /*
    ===========================================================================
    STEP 1: CUSTOMER AGGREGATION
    ===========================================================================

    Combines customer demographic information with transactional sales data.

    Granularity:
        One row per customer.

    Calculates:
        - Customer demographics
        - Revenue metrics
        - Order metrics
        - Product metrics
        - Customer lifespan
    ===========================================================================
    */

    SELECT

        -- Customer Information
        c.customer_key,
        CONCAT_WS(' ', c.first_name, c.last_name) AS full_name,
        c.marital_status,
        c.country,
        c.gender,

        -- Customer Age
        TIMESTAMPDIFF(
            YEAR,
            c.birth_date,
            CURDATE()
        ) AS age,

        -- Order Metrics
        COUNT(DISTINCT fs.order_number) AS total_orders,

        -- Customer Lifecycle Metrics
        MAX(fs.order_date) AS last_order,

        TIMESTAMPDIFF(
            MONTH,
            MIN(fs.order_date),
            MAX(fs.order_date)
        ) AS life_span_months,

        -- Revenue Metrics
        SUM(fs.sales) AS total_sales,

        ROUND(
            SUM(fs.sales) /
            COUNT(DISTINCT fs.order_number),
            2
        ) AS average_order_value,

        -- Product Metrics
        SUM(fs.quantity) AS total_quantity_purchased,

        COUNT(DISTINCT fs.product_key) AS total_products

    FROM fact_sales fs

    LEFT JOIN dim_customers c
        ON fs.customer_key = c.customer_key

    WHERE fs.order_date IS NOT NULL

    GROUP BY
        c.customer_key,
        CONCAT_WS(' ', c.first_name, c.last_name),
        c.marital_status,
        c.country,
        c.gender,
        TIMESTAMPDIFF(YEAR, c.birth_date, CURDATE())
)

-- ============================================================================
-- STEP 2: CUSTOMER PERFORMANCE REPORT
-- ============================================================================
-- Applies customer segmentation and derives business KPIs.
-- ============================================================================

SELECT

    -- Customer Information
    customer_key,
    full_name,
    marital_status,
    country,
    gender,
    age,

    /*
    ---------------------------------------------------------------------------
    Customer Segmentation
    ---------------------------------------------------------------------------
    Categorizes customers based on revenue contribution and relationship
    duration.
    ---------------------------------------------------------------------------
    */
    CASE
        WHEN total_sales > 5000
            AND life_span_months >= 12
            THEN 'VIP'

        WHEN total_sales <= 5000
            AND life_span_months >= 12
            THEN 'Regular'

        ELSE 'New'
    END AS customer_segmentation,

    /*
    ---------------------------------------------------------------------------
    Age Group Classification
    ---------------------------------------------------------------------------
    Groups customers into age brackets for demographic analysis.
    ---------------------------------------------------------------------------
    */
    CASE
        WHEN age > 50 THEN 'Above 50'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        ELSE 'Below 20'
    END AS age_range,

    -- Customer Activity Metrics
    total_orders,
    life_span_months,

    -- Product Metrics
    total_quantity_purchased,
    total_products,

    -- Revenue Metrics
    average_order_value,
    total_sales,

    /*
    ---------------------------------------------------------------------------
    Average Monthly Spend
    ---------------------------------------------------------------------------
    Measures the customer's average revenue contribution throughout their
    active lifespan.
    ---------------------------------------------------------------------------
    */
    CASE
        WHEN life_span_months = 0
            THEN total_sales

        ELSE ROUND(
            total_sales / life_span_months,
            2
        )
    END AS avg_monthly_spend,

    -- Most Recent Purchase Date
    last_order

FROM customer_base;