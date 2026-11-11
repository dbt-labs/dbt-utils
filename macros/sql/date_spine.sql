{% macro get_intervals_between(start_date, end_date, datepart) -%}
    {{ return(adapter.dispatch('get_intervals_between', 'dbt_utils')(start_date, end_date, datepart)) }}
{%- endmacro %}

{% macro default__get_intervals_between(start_date, end_date, datepart) -%}
    {%- call statement('get_intervals_between', fetch_result=True) %}

        select {{ dbt.datediff(start_date, end_date, datepart) }}

    {%- endcall -%}

    {%- set value_list = load_result('get_intervals_between') -%}

    {%- if value_list and value_list['data'] -%}
        {%- set values = value_list['data'] | map(attribute=0) | list %}
        {{ return(values[0]) }}
    {%- else -%}
        {{ return(1) }}
    {%- endif -%}

{%- endmacro %}




{% macro date_spine(datepart, start_date, end_date) %}
    {{ return(adapter.dispatch('date_spine', 'dbt_utils')(datepart, start_date, end_date)) }}
{%- endmacro %}

{% macro default__date_spine(datepart, start_date, end_date) %}


{# call as follows:

date_spine(
    "day",
    "to_date('01/01/2016', 'mm/dd/yyyy')",
    "dbt.dateadd(week, 1, current_date)"
) #}


with rawdata as (

    {{dbt_utils.generate_series(
        dbt_utils.get_intervals_between(start_date, end_date, datepart)
    )}}

),

all_periods as (

    select (
        {{
            dbt.dateadd(
                datepart,
                "row_number() over (order by generated_number) - 1",
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

{# SQL Server does not allow a `with` clause inside a subquery or CTE, so the default
   implementation cannot be nested in a model's own `with` clause. This version runs the
   spine query at compile time and returns the dates as a `union all` of literals. #}
{% macro sqlserver__date_spine(datepart, start_date, end_date) -%}

    {% set date_spine_query %}
        with

        l0 as (

            select c
            from (select 1 union all select 1) as d(c)

        ),
        l1 as (

            select
                1 as c
            from l0 as a
            cross join l0 as b

        ),

        l2 as (

            select 1 as c
            from l1 as a
            cross join l1 as b
        ),

        l3 as (

            select 1 as c
            from l2 as a
            cross join l2 as b
        ),

        l4 as (

            select 1 as c
            from l3 as a
            cross join l3 as b
        ),

        l5 as (

            select 1 as c
            from l4 as a
            cross join l4 as b
        ),

        nums as (

            select row_number() over (order by (select null)) as rownum
            from l5
        ),

        rawdata as (

            select top ({{ dbt.datediff(start_date, end_date, datepart) }}) rownum -1 as n
            from nums
            order by rownum
        ),

        all_periods as (

            select (
                {{
                    dbt.dateadd(
                        datepart,
                        'n',
                        start_date
                    )
                }}
            ) as date_{{ datepart }}
            from rawdata
        ),

        filtered as (

            select *
            from all_periods
            where date_{{ datepart }} <= {{ end_date }}

        )

        select * from filtered
        order by 1

    {% endset %}

    {% set results = run_query(date_spine_query) %}

    {% if execute %}

        {% set results_list = results.columns[0].values() %}

    {% else %}

        {% set results_list = [] %}

    {% endif %}

    {%- set spine_type = 'date' if datepart | lower in ('day', 'week', 'month', 'quarter', 'year') else dbt.type_timestamp() -%}

    {%- for date_field in results_list %}
        select cast('{{ date_field }}' as {{ spine_type }}) as date_{{ datepart }} {{ 'union all ' if not loop.last else '' }}
    {% endfor -%}

{%- endmacro %}
