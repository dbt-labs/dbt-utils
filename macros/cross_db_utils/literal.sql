
{%- macro string_literal(value) -%}
  {{ return(adapter.dispatch('string_literal', 'cc_dbt_utils') (value)) }}
{%- endmacro -%}

{% macro default__string_literal(value) -%}
    '{{ value }}'
{%- endmacro %}
