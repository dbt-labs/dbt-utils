

{% macro concat(fields) -%}
  {{ return(adapter.dispatch('concat', packages = dbt_utils._get_utils_namespaces())(fields)) }}
{%- endmacro %}

{% macro default__concat(fields) -%}
    {{ fields|join(' || ') }}
{%- endmacro %}
