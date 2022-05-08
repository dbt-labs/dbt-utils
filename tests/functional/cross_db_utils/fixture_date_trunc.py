

# date_trunc

# TODO - implement expected results here
seeds__data_date_trunc_csv = """todo,result
TODO,1
"""


models__test_date_trunc_sql = """
with data as (

    select * from {{ ref('data_date_trunc') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_date_trunc_yml = """
version: 2
models:
  - name: test_date_trunc
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
