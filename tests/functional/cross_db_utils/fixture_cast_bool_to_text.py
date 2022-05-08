

# cast_bool_to_text

# TODO - implement expected results here
seeds__data_cast_bool_to_text_csv = """todo,result
TODO,1
"""


models__test_cast_bool_to_text_sql = """
with data as (

    select * from {{ ref('data_cast_bool_to_text') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_cast_bool_to_text_yml = """
version: 2
models:
  - name: test_cast_bool_to_text
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
