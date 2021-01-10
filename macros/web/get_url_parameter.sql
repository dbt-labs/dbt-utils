{% macro get_url_parameter(field, url_parameter) -%}
    {{ return(adapter.dispatch('get_url_parameter', packages = dbt_utils._get_utils_namespaces())(field, url_parameter)) }}
{% endmacro %}

{% macro default__get_url_parameter(field, url_parameter) -%}

{%- set formatted_url_parameter = "'" + url_parameter + "='" -%}

{%- set split = dbt_utils.split_part(dbt_utils.split_part(field, formatted_url_parameter, 2), "'&'", 1) -%}

nullif({{ split }},'')

{%- endmacro %}
