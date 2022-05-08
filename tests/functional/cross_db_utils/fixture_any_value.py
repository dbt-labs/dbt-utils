

# any_value

# TODO - implement expected results here
seeds__data_any_value_csv = """todo,result
TODO,1
"""


models__test_any_value_sql = """
with data as (

    select * from {{ ref('data_any_value') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_any_value_yml = """
version: 2
models:
  - name: test_any_value
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
