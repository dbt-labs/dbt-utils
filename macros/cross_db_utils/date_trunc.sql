{% macro date_trunc(datepart, date) -%}
  {{ return(adapter.dispatch('date_trunc', 'dbt_utils') (datepart, date)) }}
{%- endmacro %}

{% macro default__date_trunc(datepart, date) -%}
  {% do dbt_utils.xdb_deprecation_warning('date_trunc', model.package_name, model.name) %}
  {{ return(adapter.dispatch('date_trunc', 'dbt') (datepart, date)) }}
{%- endmacro %}
