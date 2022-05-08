

# last_day

# TODO - implement expected results here
seeds__data_last_day_csv = """todo,result
TODO,1
"""


models__test_last_day_sql = """
with data as (

    select * from {{ ref('data_last_day') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_last_day_yml = """
version: 2
models:
  - name: test_last_day
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
