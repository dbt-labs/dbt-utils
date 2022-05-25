{% macro hash(field) -%}
  {{ return(adapter.dispatch('hash', 'dbt') (field)) }}
{%- endmacro %}
