{% test recency(model, field, datepart, interval, timestamp) %}
  {{ return(adapter.dispatch('test_recency', 'dbt_utils')(model, field, datepart, interval, timestamp)) }}
{% endtest %}

{% macro default__test_recency(model, field, datepart, interval, timestamp) %}

{% set threshold = dbt_utils.dateadd(datepart, interval * -1, dbt_utils.current_timestamp()) %}

with recency as (

    select max({{field}}) as most_recent
    from {{ model }}

)

select

    most_recent,
    {{ threshold }} as threshold

from recency
  {%- if timestamp is true %}
    where most_recent < timestamp({{ threshold }})
  {%- else %}
    where most_recent < {{ threshold }}
  {%- endif %}

{% endmacro %}
