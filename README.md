# sql-data-analytics-project
# SQL Data Analytics Project

A comprehensive collection of SQL scripts focused on data exploration, analytics, and business reporting. This project demonstrates how SQL can be used to transform raw data into actionable insights through exploratory analysis, KPI development, customer and product segmentation, trend analysis, and performance reporting.

The repository contains analytical SQL queries designed to help data analysts, business intelligence professionals, and aspiring data engineers efficiently explore, validate, and analyze data stored in relational databases. Each script focuses on a specific analytical domain and showcases SQL best practices for solving real-world business problems.

## Key Areas Covered

- Database Exploration
- Measures and KPI Development
- Customer Analytics
- Product Performance Analysis
- Time-Based Trend Analysis
- Cumulative Analytics
- Customer Segmentation
- Product Segmentation
- Revenue Analysis
- Business Reporting

## Technologies

- SQL
- MySQL
- Data Analytics
- Business Intelligence
- Data Warehousing

This project serves as a practical portfolio demonstrating analytical thinking, SQL proficiency, and the ability to translate business requirements into meaningful data insights.
## Data Source & Processing Layers

This project implements a Medallion Architecture to transform raw source data into analytics-ready datasets. The complete ETL pipeline is organized into distinct layers, each serving a specific purpose in the data transformation journey.

### Data Sources
Raw source files used throughout the project are available in the Dataset folder:

📁 Dataset:
https://github.com/Samuel-Boye-Abroquah/sql-data-warehouse-project/tree/main/Dataset

### Bronze Layer
The Bronze layer serves as the ingestion layer where raw source data is loaded into the warehouse without significant transformations, preserving the original structure and content.

📁 Bronze Scripts:
https://github.com/Samuel-Boye-Abroquah/sql-data-warehouse-project/tree/main/scripts/bronze

### Silver Layer
The Silver layer focuses on data cleansing, standardization, validation, and enrichment. This stage improves data quality and prepares datasets for analytical modeling.

📁 Silver Scripts:
https://github.com/Samuel-Boye-Abroquah/sql-data-warehouse-project/tree/main/scripts/Silver

### Gold Layer
The Gold layer contains business-ready dimensional models, fact tables, and analytical views designed to support reporting, business intelligence, and decision-making.

📁 Gold Scripts:
https://github.com/Samuel-Boye-Abroquah/sql-data-warehouse-project/tree/main/scripts/gold

Key assets include:
- dim_customers
- dim_products
- fact_sales
- vw_customer_performance_analysis
- vw_product_performance_analysis

This layered architecture demonstrates ETL development, data modeling, data quality management, and analytical reporting best practices commonly used in modern data warehousing solutions.
