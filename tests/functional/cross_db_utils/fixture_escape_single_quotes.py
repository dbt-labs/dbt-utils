
# escape_single_quotes

models__test_escape_single_quotes_quote_sql = """
select '{{ dbt_utils.escape_single_quotes("they're") }}' as actual, 'they''re' as expected {{ dbt_utils.from_dual() }} union all
select '{{ dbt_utils.escape_single_quotes("they are") }}' as actual, 'they are' as expected {{ dbt_utils.from_dual() }}
"""


# The expected literal is 'they\'re'. The second backslash is to escape it from Python.
models__test_escape_single_quotes_backslash_sql = """
select '{{ dbt_utils.escape_single_quotes("they're") }}' as actual, 'they\\'re' as expected {{ dbt_utils.from_dual() }} union all
select '{{ dbt_utils.escape_single_quotes("they are") }}' as actual, 'they are' as expected {{ dbt_utils.from_dual() }}
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
