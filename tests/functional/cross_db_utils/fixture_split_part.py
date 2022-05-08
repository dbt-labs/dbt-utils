

# split_part

# TODO - implement expected results here
seeds__data_split_part_csv = """todo,result
TODO,1
"""


models__test_split_part_sql = """
with data as (

    select * from {{ ref('data_split_part') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_split_part_yml = """
version: 2
models:
  - name: test_split_part
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
