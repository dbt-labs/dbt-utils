

# string_literal

# TODO - implement expected results here
seeds__data_string_literal_csv = """todo,result
TODO,1
"""


models__test_string_literal_sql = """
with data as (

    select * from {{ ref('data_string_literal') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_string_literal_yml = """
version: 2
models:
  - name: test_string_literal
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
