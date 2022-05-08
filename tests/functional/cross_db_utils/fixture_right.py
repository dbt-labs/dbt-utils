

# right

# TODO - implement expected results here
seeds__data_right_csv = """todo,result
TODO,1
"""


models__test_right_sql = """
with data as (

    select * from {{ ref('data_right') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_right_yml = """
version: 2
models:
  - name: test_right
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
