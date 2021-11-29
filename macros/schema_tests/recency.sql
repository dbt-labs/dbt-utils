{% test recency(model, field, datepart, interval, group_vars) %}
  {{ return(adapter.dispatch('test_recency', 'dbt_utils')(model, field, datepart, interval, group_vars)) }}
{% endtest %}

{% macro default__test_recency(model, field, datepart, interval, group_vars) %}

{% set threshold = dbt_utils.dateadd(datepart, interval * -1, dbt_utils.current_timestamp()) %}
{% set group_vars = group_vars|default([]) %}

with recency as (

    select 
      
      {% for var in group_vars %}
        {{var}},
      {% endfor %}

      max({{field}}) as most_recent

    from {{ model }}

    {% if group_vars|length > 0 %}
    {{ dbt_utils.group_by(n = group_vars|length) }}
    {% endif %}

)

select

    {% for var in group_vars %}
      {{var}},
    {% endfor %}
    most_recent,
    {{ threshold }} as threshold

from recency
where most_recent < {{ threshold }}

{% endmacro %}
