{% macro get_intervals_between(start_date, end_date, datepart) -%}

    {%- call statement('get_intervals_between', fetch_result=True) %}

        select {{dbt_utils.datediff(start_date, end_date, datepart)}}

    {%- endcall -%}

    {%- set value_list = load_result('get_intervals_between') -%}

    {%- if value_list and value_list['data'] -%}
        {%- set values = value_list['data'] | map(attribute=0) | list %}
        {{ return(values[0]) }}
    {%- else -%}
        {{ return(1) }}
    {%- endif -%}

{%- endmacro %}

{# private, don't call from anywhere else #}
{%- macro date_spine__parse_end_date(end_date) -%}
  {{ adapter_macro('dbt_utils.date_spine__parse_end_date', end_date) }}
{%- endmacro -%}


{%- macro default__date_spine__parse_end_date(end_date) -%}
    {{ end_date }}
{%- endmacro -%}


{%- macro bigquery__date_spine__parse_end_date(end_date) -%}
    {{ dbt_utils.safe_cast(end_date, dbt_utils.type_datetime()) }}
{%- endmacro -%}


{% macro date_spine(datepart, start_date, end_date) %}

/*
call as follows:

date_spine(
    "day",
    "to_date('01/01/2016', 'mm/dd/yyyy')",
    "dateadd(week, 1, current_date)"
)

*/

with rawdata as (

    {{dbt_utils.generate_series(
        dbt_utils.get_intervals_between(start_date, end_date, datepart)
    )}}

),

all_periods as (

    select (
        {{
            dbt_utils.dateadd(
                datepart,
                "row_number() over (order by 1) - 1",
                start_date
            )
        }}
    ) as date_{{datepart}}
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_{{datepart}} <= {{ dbt_utils.date_spine__parse_end_date(end_date) }}

)

select * from filtered

{% endmacro %}
