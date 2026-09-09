CREATE OR REPLACE VIEW report_sales_monthly AS 
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month_year,
    SUM(sales) AS total_sales
FROM
    fact_sales
GROUP BY 1