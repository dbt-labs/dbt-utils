{% macro ceil(fields) -%}
  {{ return(adapter.dispatch('ceil', packages = dbt_utils._get_utils_namespaces())(fields)) }}
{%- endmacro %}

{% macro default__ceil(fields) -%}
    ceil({{ fields }}) 
{%- endmacro %}

{% macro alternative_ceil(fields) %}
    ceiling({{ fields }})
{% endmacro %}
