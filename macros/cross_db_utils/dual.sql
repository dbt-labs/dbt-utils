{%- macro from_dual() -%}
  {{ return(adapter.dispatch('from_dual', 'dbt_utils')()) }}
{%- endmacro -%}

{% macro default__from_dual() %}
{% endmacro %}

{% macro snowflake__from_dual() %}
    from dual
{% endmacro %}

{% macro oracle__from_dual() %}
    from dual
{% endmacro %}
