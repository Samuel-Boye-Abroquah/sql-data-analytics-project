# SQL Data Analytics Project

Business analytics built entirely in SQL on top of a clean, governed star schema (`dim_customers`, `dim_products`, `fact_sales`) — exploratory analysis, magnitude and ranking breakdowns, time-based trends, cumulative growth, year-over-year performance, part-to-whole proportions, and customer/product segmentation.

This project is intentionally scoped to **analysis only**. The data itself — the cleaning, validation, and dimensional modeling that makes this analysis possible — lives in a separate, standalone project:

**➡ [sql-data-warehouse-project](https://github.com/Samuel-Boye-Abroquah/sql-data-warehouse-project)** — the full Bronze → Silver → Gold pipeline, from raw CRM/ERP source files through to the validated Gold-layer tables used here.

---

## Process Flow

![Data Flow: Source to Gold Layer](https://github.com/Samuel-Boye-Abroquah/sql-data-warehouse-project/blob/main/documents/data_flow_bronze_silver_gold.png)

*(Full architecture and data quality documentation: see the [Data Warehousing project](https://github.com/Samuel-Boye-Abroquah/sql-data-warehouse-project).)*

---

## What's in this project

| File | Covers |
|---|---|
| `01_exploratory_data_analysis.sql` | Date ranges, customer demographics, distinct value checks |
| `02_magnitude_analysis.sql` | Headline totals and breakdowns by country, gender, category |
| `03_ranking_analysis.sql` | Top/bottom products and customers by revenue and order count |
| `04_change_over_time_analysis.sql` | Yearly and monthly sales trends |
| `05_cumulative_analysis.sql` | Running total of sales over time |
| `06_performance_analysis.sql` | Year-over-year product performance vs. historical average |
| `07_part_to_whole_analysis.sql` | Revenue share by category, country, and customer gender |
| `08_data_segmentation_analysis.sql` | Product cost-range segments; customer VIP/Regular/New segments |
| `09_performance_view.sql` | vw_product_performance_analysis; vw_customer_performance_analysis; report_sales_monthly |

---

## Prerequisite

This project queries three view directly — `dim_customers`, `dim_products`, `fact_sales` — plus two reporting views, `vw_customer_performance_analysis` and `vw_product_performance_analysis`. All five are built by the [Data Warehousing project](https://github.com/Samuel-Boye-Abroquah/sql-data-warehouse-project); run that project's setup first, then run any script here against the resulting database.

---

## Tools

SQL (MySQL 8) — CTEs, window functions (`LAG`, `SUM() OVER`, `AVG() OVER`), aggregate and analytical functions.

---
## 📊 Sample Findings

A few outputs from the analysis suite, so you can see what the queries produce:

- **Top-selling product** — [product name] generated ~$X in revenue
- **Most concentrated category** — [category] accounts for ~X% of total revenue
- **Highest-value segment** — VIP customers (~X% of base) contribute ~X% of revenue
- **Fastest-growing year** — [year] showed the largest YoY sales increase at ~X%
  
Full result sets are in the individual SQL files.
---

## About

Built by **Samuel Boye Abroquah** — Quality Assurance Technician and Data Analytics Professional applying 12+ years of process-validation discipline to data engineering, business intelligence, and analytical system design.


[LinkedIn](https://linkedin.com/in/Samuel-Boye-Abroquah) · [Data Warehousing project](https://github.com/Samuel-Boye-Abroquah/sql-data-warehouse-project)
