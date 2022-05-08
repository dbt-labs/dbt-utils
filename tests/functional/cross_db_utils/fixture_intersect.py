

# intersect

# TODO - implement expected results here
seeds__data_intersect_csv = """todo,result
TODO,1
"""


models__test_intersect_sql = """
with data as (

    select * from {{ ref('data_intersect') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_intersect_yml = """
version: 2
models:
  - name: test_intersect
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
