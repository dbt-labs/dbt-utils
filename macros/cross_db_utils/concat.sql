{% macro concat(fields) -%}
  {{ return(adapter.dispatch('concat', 'dbt')(fields)) }}
{%- endmacro %}
