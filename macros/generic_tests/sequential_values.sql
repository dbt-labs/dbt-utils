{% test sequential_values(model, column_name, interval=1, datepart=None, group_by_columns = []) %}

  {{ return(adapter.dispatch('test_sequential_values', 'dbt_utils')(model, column_name, interval, datepart, group_by_columns)) }}

{% endtest %}

{% macro default__test_sequential_values(model, column_name, interval=1, datepart=None, group_by_columns = []) %}

{% set previous_column_name = "previous_" ~ dbt_utils.slugify(column_name) %}

{% if group_by_columns|length() > 0 %}
  {% set select_gb_cols = group_by_columns|join(',') + ', ' %}
  {% set partition_gb_cols = 'partition by ' + group_by_columns|join(',') %}
{% endif %}

with windowed as (

    select
        {{ select_gb_cols }}
        {{ column_name }},
        lag({{ column_name }}) over (
            {{partition_gb_cols}}
            order by {{ column_name }}
        ) as {{ previous_column_name }}
    from {{ model }}
),

validation_errors as (
    select
        *
    from windowed
    {% if datepart %}
    where not(cast({{ column_name }} as {{ dbt.type_timestamp() }})= cast({{ dbt.dateadd(datepart, interval, previous_column_name) }} as {{ dbt.type_timestamp() }}))
    {% else %}
    where not({{ column_name }} = {{ previous_column_name }} + {{ interval }})
    {% endif %}
)

select *
from validation_errors

{% endmacro %}
