/*
===============================================================================
VIEW: vw_product_performance_analysis
===============================================================================

PURPOSE
    This report provides a comprehensive analysis of product performance by
    combining sales transactions with product master data.

BUSINESS OBJECTIVES
    - Identify top-performing and underperforming products
    - Measure product sales activity and customer reach
    - Evaluate product revenue generation over time
    - Support inventory and product portfolio decisions

KEY METRICS
    - Total Orders
    - Total Sales Revenue
    - Total Quantity Sold
    - Total Customers
    - Product Lifespan (Months)
    - Product Recency
    - Average Selling Price
    - Average Order Revenue (AOR)
    - Average Monthly Revenue

PRODUCT SEGMENTS
    High-Performer : Revenue > 50,000
    Mid-Range      : Revenue >= 10,000
    Low-Performer  : Revenue < 10,000

===============================================================================
*/

CREATE OR REPLACE VIEW vw_product_performance_analysis AS

WITH base_query AS (

    /*
    ===========================================================================
    STEP 1: BUILD BASE DATASET
    ===========================================================================

    Combines:
        - Product dimension data
        - Sales fact data

    Purpose:
        Create a product-level transactional dataset that serves as the
        foundation for all downstream aggregations.

    Filters:
        Retain only products with at least one recorded sale.
    ===========================================================================
    */

    SELECT
        -- Sales Information
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales AS sales_amount,
        f.quantity,

        -- Product Information
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost_price

    FROM dim_products p

    LEFT JOIN fact_sales f
        ON f.product_key = p.product_key

    WHERE f.order_date IS NOT NULL
),

product_aggregations AS (

    /*
    ===========================================================================
    STEP 2: AGGREGATE PRODUCT PERFORMANCE METRICS
    ===========================================================================

    Calculates KPIs for each product, including:

        - Sales performance
        - Customer adoption
        - Product lifespan
        - Average selling price

    Granularity:
        One row per product.
    ===========================================================================
    */

    SELECT

        -- Product Attributes
        product_key,
        product_name,
        category,
        subcategory,
        cost_price,

        -- Product Lifecycle Metrics
        TIMESTAMPDIFF(
            MONTH,
            MIN(order_date),
            MAX(order_date)
        ) AS lifespan,

        MAX(order_date) AS last_sale_date,

        -- Activity Metrics
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,

        -- Revenue Metrics
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,

        -- Average Selling Price Per Unit
        ROUND(
            AVG(
                sales_amount / NULLIF(quantity, 0)
            ),
            1
        ) AS avg_selling_price

    FROM base_query

    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost_price
)

-- ============================================================================
-- STEP 3: FINAL PRODUCT PERFORMANCE REPORT
-- ============================================================================
-- Combines aggregated metrics with derived KPIs and business segments.
-- ============================================================================

SELECT

    -- Product Information
    product_key,
    product_name,
    category,
    subcategory,
    cost_price,

    -- Product Activity
    last_sale_date,

    -- Months Since Last Sale
    TIMESTAMPDIFF(
        MONTH,
        last_sale_date,
        CURDATE()
    ) AS recency_in_months,

    /*
    ---------------------------------------------------------------------------
    Product Revenue Segmentation
    ---------------------------------------------------------------------------
    Classifies products based on total revenue contribution.
    ---------------------------------------------------------------------------
    */
    CASE
        WHEN total_sales > 50000
            THEN 'High-Performer'

        WHEN total_sales >= 10000
            THEN 'Mid-Range'

        ELSE 'Low-Performer'
    END AS product_segment,

    -- Lifecycle Metrics
    lifespan,

    -- Sales Metrics
    total_orders,
    total_sales,
    total_quantity,
    total_customers,

    -- Pricing Metrics
    avg_selling_price,

    /*
    ---------------------------------------------------------------------------
    Average Order Revenue (AOR)

    Indicates the average revenue generated per order.
    ---------------------------------------------------------------------------
    */
    CASE
        WHEN total_orders = 0
            THEN 0

        ELSE ROUND(
            total_sales / total_orders,
            2
        )
    END AS avg_order_revenue,

    /*
    ---------------------------------------------------------------------------
    Average Monthly Revenue

    Measures the average revenue generated throughout the product's active
    selling lifespan.
    ---------------------------------------------------------------------------
    */
    CASE
        WHEN lifespan = 0
            THEN total_sales

        ELSE ROUND(
            total_sales / lifespan,
            2
        )
    END AS avg_monthly_revenue

FROM product_aggregations;