{# This is here for backwards compatibility only #}

{% macro concat(fields) -%}
  {{ return(adapter.dispatch('concat', 'dbt_utils')(fields)) }}
{%- endmacro %}

{% macro default__concat(fields) -%}
  {{ return(adapter.dispatch('concat', 'dbt')(fields)) }}
{%- endmacro %}
