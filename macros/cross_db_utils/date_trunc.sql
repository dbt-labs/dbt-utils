{% macro date_trunc(datepart, date) -%}
  {{ return(adapter.dispatch('date_trunc', 'dbt') (datepart, date)) }}
{%- endmacro %}
