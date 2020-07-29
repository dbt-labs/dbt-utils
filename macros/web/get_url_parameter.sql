{% macro get_url_parameter(field, url_parameter) -%}

{%- set formatted_url_parameter = "'" + url_parameter + "='" -%}

{%- set split = cc_dbt_utils.split_part(cc_dbt_utils.split_part(field, formatted_url_parameter, 2), "'&'", 1) -%}

nullif({{ split }},'')

{%- endmacro %}
