{% test recency(model, field, datepart, interval, group_by_columns = []) %}
  {{ return(adapter.dispatch('test_recency', 'dbt_utils')(model, field, datepart, interval, group_by_columns)) }}
{% endtest %}

{% macro default__test_recency(model, field, datepart, interval, group_by_columns) %}

{% set threshold = dbt_utils.dateadd(datepart, interval * -1, dbt_utils.current_timestamp()) %}
{% if group_by_columns|length() > 0 %}
  {% set select_gb_cols = group_by_columns|join(' ,') + ', ' %}
  {% set groupby_gb_cols = 'group by ' + group_by_columns|join(',') %}
{% endif %}


with recency as (

    select 

      {{ select_gb_cols }}
      max({{field}}) as most_recent

    from {{ model }}

    {{ groupby_gb_cols }}

)

select

    {{ select_gb_cols }}
    most_recent,
    {{ threshold }} as threshold

from recency
where most_recent < {{ threshold }}

{% endmacro %}
