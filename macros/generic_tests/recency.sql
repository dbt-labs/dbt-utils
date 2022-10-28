{% test recency(model, field, datepart, interval, group_by_columns = []) %}
  {{ return(adapter.dispatch('test_recency', 'dbt_utils')(model, field, datepart, interval, group_by_columns)) }}
{% endtest %}

{% macro default__test_recency(model, field, datepart, interval, group_by_columns) %}

{#- Get columns in model #}
{%- set columns = adapter.get_columns_in_relation(model) %}

{#- Get column type of field in model #}
{%- set column_type = columns | selectattr("name", "==", field) | map(attribute="data_type") | first %}

{#- Use a date-based threshold if column type is DATE or datepart is day or greater #}
{%- if column_type == 'DATE' and datepart in ['year', 'quarter', 'month', 'week', 'day'] %}
  {%- set threshold = dbt.dateadd(datepart, interval * -1, dbt.safe_cast(dbt.current_timestamp_backcompat(), 'date')) %}
{%- else %}
  {%- set threshold = dbt.dateadd(datepart, interval * -1, dbt.current_timestamp_backcompat()) %}
{%- endif %}


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