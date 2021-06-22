{% macro ceil(field) -%}
  {{ return(adapter.dispatch('ceil', packages = dbt_utils._get_utils_namespaces())(field)) }}
{%- endmacro %}

{% macro default__ceil(field) -%}
    ceil({{ field }})
{%- endmacro %}

{% macro alternative_ceil(field) %}
    ceiling({{ field }})
{% endmacro %}
