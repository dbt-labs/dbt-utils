{% macro safe_divide(numerator, denominator) -%}
  {{ return(adapter.dispatch('safe_divide', 'dbt_utils')(numerator, denominator)) }}
{%- endmacro %}

{% macro default__safe_divide(numerator, denominator) %}
    ( {{ numerator }} ) / nullif( ( {{ denominator }} ), 0)
{% endmacro %}