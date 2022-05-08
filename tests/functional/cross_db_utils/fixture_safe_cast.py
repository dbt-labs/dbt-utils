

# safe_cast

# TODO - implement expected results here
seeds__data_safe_cast_csv = """todo,result
TODO,1
"""


models__test_safe_cast_sql = """
with data as (

    select * from {{ ref('data_safe_cast') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_safe_cast_yml = """
version: 2
models:
  - name: test_safe_cast
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
