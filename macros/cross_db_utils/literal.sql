
{%- macro string_literal(value) -%}
  {{ adapter_macro('dbt_utils.string_literal', value) }}
{%- endmacro -%}

{% macro default__string_literal(value) -%}
    '{{ value }}'
{%- endmacro %}
