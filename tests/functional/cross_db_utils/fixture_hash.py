

# hash

# TODO - implement expected results here
seeds__data_hash_csv = """todo,result
TODO,1
"""


models__test_hash_sql = """
with data as (

    select * from {{ ref('data_hash') }}

)

# TODO - implement actual logic here
select

    1 actual,
    result as expected

from data
"""


models__test_hash_yml = """
version: 2
models:
  - name: test_hash
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
