

# except

# TODO - implement expected results here
seeds__data_except_csv = """todo,result
TODO,1
"""


models__test_except_sql = """
with data as (

    select * from {{ ref('data_except') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_except_yml = """
version: 2
models:
  - name: test_except
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
