{% macro date_spine(table, datepart, start_date, end_date) %}

/*
call as follows:

date_spine(
    ref('organizations'),
    "minute",
    "to_date('01/01/2016', 'mm/dd/yyyy')",
    "dateadd(week, 1, current_date)"
)

*/

with rawdata as (

    select * from {{ table }}

),

all_periods as (

    select (
        {{
            dbt_utils.dateadd(
                datepart,
                "row_number() over () - 1",
                start_date
            )
        }}
    ) as date_{{datepart}}
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_{{datepart}} <= {{ end_date }}

)

select * from filtered

{% endmacro %}
