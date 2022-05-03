macros__test_assert_equal_sql = """
{% test assert_equal(model, actual, expected) %}
select * from {{ model }} where {{ actual }} != {{ expected }}

{% endtest %}
"""


# dateadd

seeds__data_dateadd_csv = """from_time,interval_length,datepart,result
2018-01-01 01:00:00,1,day,2018-01-02 01:00:00
2018-01-01 01:00:00,1,month,2018-02-01 01:00:00
2018-01-01 01:00:00,1,year,2019-01-01 01:00:00
2018-01-01 01:00:00,1,hour,2018-01-01 02:00:00
,1,day,
"""


models__test_dateadd_sql = """
with data as (

    select * from {{ ref('data_dateadd') }}

)

select
    case
        when datepart = 'hour' then cast({{ dbt_utils.dateadd('hour', 'interval_length', 'from_time') }} as {{dbt_utils.type_timestamp()}})
        when datepart = 'day' then cast({{ dbt_utils.dateadd('day', 'interval_length', 'from_time') }} as {{dbt_utils.type_timestamp()}})
        when datepart = 'month' then cast({{ dbt_utils.dateadd('month', 'interval_length', 'from_time') }} as {{dbt_utils.type_timestamp()}})
        when datepart = 'year' then cast({{ dbt_utils.dateadd('year', 'interval_length', 'from_time') }} as {{dbt_utils.type_timestamp()}})
        else null
    end as actual,
    result as expected

from data
"""

models__test_dateadd_yml = """
version: 2
models:
  - name: test_dateadd
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""


# datediff

seeds__data_datediff_csv = """first_date,second_date,datepart,result
2018-01-01 01:00:00,2018-01-02 01:00:00,day,1
2018-01-01 01:00:00,2018-02-01 01:00:00,month,1
2018-01-01 01:00:00,2019-01-01 01:00:00,year,1
2018-01-01 01:00:00,2018-01-01 02:00:00,hour,1
2018-01-01 01:00:00,2018-01-01 02:01:00,minute,61
2018-01-01 01:00:00,2018-01-01 02:00:01,second,3601
2019-12-31 00:00:00,2019-12-27 00:00:00,week,-1
2019-12-31 00:00:00,2019-12-30 00:00:00,week,0
2019-12-31 00:00:00,2020-01-02 00:00:00,week,0
2019-12-31 00:00:00,2020-01-06 02:00:00,week,1
,2018-01-01 02:00:00,hour,
2018-01-01 02:00:00,,hour,
"""


models__test_datediff_sql = """
with data as (

    select * from {{ ref('data_datediff') }}

)

select

    case
        when datepart = 'second' then {{ dbt_utils.datediff('first_date', 'second_date', 'second') }}
        when datepart = 'minute' then {{ dbt_utils.datediff('first_date', 'second_date', 'minute') }}
        when datepart = 'hour' then {{ dbt_utils.datediff('first_date', 'second_date', 'hour') }}
        when datepart = 'day' then {{ dbt_utils.datediff('first_date', 'second_date', 'day') }}
        when datepart = 'week' then {{ dbt_utils.datediff('first_date', 'second_date', 'week') }}
        when datepart = 'month' then {{ dbt_utils.datediff('first_date', 'second_date', 'month') }}
        when datepart = 'year' then {{ dbt_utils.datediff('first_date', 'second_date', 'year') }}
        else null
    end as actual,
    result as expected

from data

-- Also test correct casting of literal values.

union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "microsecond") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "millisecond") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "second") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "minute") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "hour") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "day") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-03 00:00:00.000000'", "week") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "month") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "quarter") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "year") }} as actual, 1 as expected
"""


models__test_datediff_yml = """
version: 2
models:
  - name: test_datediff
    tests:
      - assert_equal:
          actual: actual
          expected: expected
"""
