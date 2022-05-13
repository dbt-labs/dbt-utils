
# string_literal

models__test_string_literal_sql = """
select {{ dbt_utils.string_literal("abc") }} as actual, 'abc' as expected {{ from_dual() }} union all
select {{ dbt_utils.string_literal("1") }} as actual, '1' as expected {{ from_dual() }} union all
select {{ dbt_utils.string_literal("") }} as actual, '' as expected {{ from_dual() }} union all
select {{ dbt_utils.string_literal(none) }} as actual, 'None' as expected {{ from_dual() }}
"""


models__test_string_literal_yml = """
version: 2
models:
  - name: test_string_literal
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
