

# listagg

# TODO - implement expected results here
seeds__data_listagg_csv = """todo,result
TODO,1
"""


models__test_listagg_sql = """
with data as (

    select * from {{ ref('data_listagg') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_listagg_yml = """
version: 2
models:
  - name: test_listagg
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
