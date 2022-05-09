
# escape_single_quotes

# Postgres and Redshift
models__test_escape_single_quotes_sql = """
select '{{ dbt_utils.escape_single_quotes("they're") }}' as actual, 'they''re' as expected union all
select '{{ dbt_utils.escape_single_quotes("they are") }}' as actual, 'they are' as expected
"""

# Snowflake and BigQuery
# The expected literal is actually 'they\'re', but we need to escape the backslash
models__test_escape_single_quotes_sql_snowflake_bigquery = """
select '{{ dbt_utils.escape_single_quotes("they're") }}' as actual, 'they\\'re' as expected union all
select '{{ dbt_utils.escape_single_quotes("they are") }}' as actual, 'they are not' as expected
"""


models__test_escape_single_quotes_yml = """
version: 2
models:
  - name: test_escape_single_quotes
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
