{# string  -------------------------------------------------     #}

{% macro type_string() %}
  {{ adapter_macro('dbt_utils.type_string') }}
{% endmacro %}

{% macro default__type_string() %}
    string
{% endmacro %}

{%- macro redshift__type_string() -%}
    varchar
{%- endmacro -%}

{% macro postgres__type_string() %}
    varchar
{% endmacro %}

{% macro snowflake__type_string() %}
    varchar
{% endmacro %}
