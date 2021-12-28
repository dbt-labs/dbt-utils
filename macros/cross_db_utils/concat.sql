

{% macro concat(fields) -%}
  {{ return(adapter.dispatch('concat', 'cc_dbt_utils')(fields)) }}
{%- endmacro %}

{% macro default__concat(fields) -%}
    {{ fields|join(' || ') }}
{%- endmacro %}
