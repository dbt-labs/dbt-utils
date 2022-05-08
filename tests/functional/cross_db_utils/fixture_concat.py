

# concat

# TODO - implement expected results here
seeds__data_concat_csv = """todo,result
TODO,1
"""


models__test_concat_sql = """
with data as (

    select * from {{ ref('data_concat') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_concat_yml = """
version: 2
models:
  - name: test_concat
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
