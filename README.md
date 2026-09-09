cd path/to/sql-data-warehouse-project

# make sure the final dim_products fix and both fixed analysis files are in place
git add scripts/gold/ddl_gold.sql scripts/gold/ddl_gold_reports.sql
git commit -m "Fix dim_products deduplication to use stable product number"

git add analysis/
git commit -m "Add full analysis suite: exploratory through segmentation"

git add README.md
git commit -m "Add final project README"

git push
