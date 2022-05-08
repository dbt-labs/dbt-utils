

# escape_single_quotes

# TODO - implement expected results here
seeds__data_escape_single_quotes_csv = """todo,result
TODO,1
"""


models__test_escape_single_quotes_sql = """
with data as (

    select * from {{ ref('data_escape_single_quotes') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_escape_single_quotes_yml = """
version: 2
models:
  - name: test_escape_single_quotes
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
