{% macro hash(field) -%}
  {{ return(adapter.dispatch('hash', 'dbt_utils') (field)) }}
{%- endmacro %}

{% macro default__hash(field) -%}
  {% do dbt_utils.xdb_deprecation_warning('hash', model.package_name, model.name) %}
  {{ return(adapter.dispatch('hash', 'dbt') (field)) }}
{%- endmacro %}
