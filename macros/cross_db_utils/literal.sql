
{%- macro string_literal(value) -%}
  {{ adapter.dispatch('string_literal', packages = cc_dbt_utils._get_utils_namespaces()) (value) }}
{%- endmacro -%}

{% macro default__string_literal(value) -%}
    '{{ value }}'
{%- endmacro %}
