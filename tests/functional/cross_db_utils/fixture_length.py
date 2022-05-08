

# length

# TODO - implement expected results here
seeds__data_length_csv = """todo,result
TODO,1
"""


models__test_length_sql = """
with data as (

    select * from {{ ref('data_length') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_length_yml = """
version: 2
models:
  - name: test_length
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
