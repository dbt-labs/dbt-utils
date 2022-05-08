

# bool_or

# TODO - implement expected results here
seeds__data_bool_or_csv = """todo,result
TODO,1
"""


models__test_bool_or_sql = """
with data as (

    select * from {{ ref('data_bool_or') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_bool_or_yml = """
version: 2
models:
  - name: test_bool_or
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
