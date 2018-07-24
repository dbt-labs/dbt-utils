
test-postgres:
	dbt seed --target postgres
	dbt run --target postgres
	dbt test --target postgres

test-redshift:
	dbt seed --target redshift
	dbt run --target redshift
	dbt test --target redshift

test-snowflake:
	dbt seed --target snowflake
	dbt run --target snowflake
	dbt test --target snowflake

test-bigquery:
	dbt seed --target bigquery
	dbt run --target bigquery
	dbt test --target bigquery

test-all: test-postgres test-redshift test-snowflake test-bigquery
	echo "Completed successfully"
