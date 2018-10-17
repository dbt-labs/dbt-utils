
test-postgres:
	dbt seed --target postgres --full-refresh
	dbt run --target postgres --full-refresh --exclude test_insert_by_period
	dbt test --target postgres --exclude test_insert_by_period

test-redshift:
	dbt seed --target redshift --full-refresh
	dbt run --target redshift --full-refresh
	dbt test --target redshift

test-snowflake:
	dbt seed --target snowflake --full-refresh
	dbt run --target snowflake --full-refresh
	dbt test --target snowflake

test-bigquery:
	dbt seed --target bigquery --full-refresh
	dbt run --target bigquery --full-refresh
	dbt test --target bigquery

test-all: test-postgres test-redshift test-snowflake test-bigquery
	echo "Completed successfully"
