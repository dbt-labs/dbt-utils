{% macro all_days(table, start_date, end_date) %}

/*
call this as follows:
{{
    all_days(
        ref('model name with lots of records in it'),
        "to_date('01/01/2009', 'mm/dd/yyyy')",
        "dateadd(year, 1, current_date)"
    )
}}
*/

with events as (

    select * from {{ table }}

),

all_the_days as (

    select (
        dateadd(
            day,
            row_number() over () - 1,
            {{ start_date }}
            )
        )::date as date_day
    from events

),

filtered as (

    select *
    from all_the_days
    where date_day <= {{ end_date }}

)

select * from filtered

{% endmacro %}
