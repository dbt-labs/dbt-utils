{% macro concat(fields) -%}
  {{ return(adapter.dispatch('concat', 'dbt_utils')(fields)) }}
{%- endmacro %}

{% macro default__concat(fields) -%}
  {% do dbt_utils.xdb_deprecation_warning('concat', model.package_name, model.name) %}
  {{ return(adapter.dispatch('concat', 'dbt')(fields)) }}
{%- endmacro %}
