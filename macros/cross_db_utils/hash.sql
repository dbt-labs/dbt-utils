{# This is here for backwards compatibility only #}

{% macro hash(field) -%}
  {{ return(adapter.dispatch('hash', 'dbt_utils') (field)) }}
{%- endmacro %}

{% macro default__hash(field) -%}
  {{ return(adapter.dispatch('hash', 'dbt') (field)) }}
{%- endmacro %}
