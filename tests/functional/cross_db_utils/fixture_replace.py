

# replace

# TODO - implement expected results here
seeds__data_replace_csv = """todo,result
TODO,1
"""


models__test_replace_sql = """
with data as (

    select * from {{ ref('data_replace') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_replace_yml = """
version: 2
models:
  - name: test_replace
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
