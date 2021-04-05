{% macro test_sequential_values(model, column_name, interval=1, datepart=None) %}

  {{ return(adapter.dispatch('test_sequential_values', packages=dbt_utils._get_utils_namespaces())(model, column_name, interval, datepart, **kwargs)) }}

{% endmacro %}

{% macro default__test_sequential_values(model, column_name, interval, datepart) %}

with windowed as (

    select
        {{ column_name }},
        lag({{ column_name }}) over (
            order by {{ column_name }}
        ) as previous_{{ column_name }}
    from {{ model }}
),

validation_errors as (
    select
        *
    from windowed
    {% if datepart %}
    where not(cast({{ column_name }} as timestamp)= cast({{ dbt_utils.dateadd(datepart, interval, 'previous_' + column_name) }} as timestamp))
    {% else %}
    where not({{ column_name }} = previous_{{ column_name }} + {{ interval }})
    {% endif %}
)

select
    count(*)
from validation_errors

{% endmacro %}
