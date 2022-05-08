

# position

# TODO - implement expected results here
seeds__data_position_csv = """todo,result
TODO,1
"""


models__test_position_sql = """
with data as (

    select * from {{ ref('data_position') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_position_yml = """
version: 2
models:
  - name: test_position
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
