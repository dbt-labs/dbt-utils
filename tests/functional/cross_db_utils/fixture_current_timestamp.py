

# current_timestamp

# TODO - implement expected results here
seeds__data_current_timestamp_csv = """todo,result
TODO,1
"""


models__test_current_timestamp_sql = """
with data as (

    select * from {{ ref('data_current_timestamp') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_current_timestamp_yml = """
version: 2
models:
  - name: test_current_timestamp
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
