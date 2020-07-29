{% macro concat(fields) -%}
  {{ adapter_macro('cc_dbt_utils.concat', fields) }}
{%- endmacro %}


{% macro default__concat(fields) -%}
    concat({{ fields|join(', ') }})
{%- endmacro %}


{% macro alternative_concat(fields) %}
    {{ fields|join(' || ') }}
{% endmacro %}


{% macro redshift__concat(fields) %}
    {{cc_dbt_utils.alternative_concat(fields)}}
{% endmacro %}


{% macro snowflake__concat(fields) %}
    {{cc_dbt_utils.alternative_concat(fields)}}
{% endmacro %}
