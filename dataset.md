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
