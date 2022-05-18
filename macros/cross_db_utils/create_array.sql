{% macro create_array(inputs) -%}
  {{ return(adapter.dispatch('array', 'dbt_utils')(inputs)) }}
{%- endmacro %}

{% macro default__array(inputs) -%}
    array[ {{ inputs|join(' , ') }} ]
{%- endmacro %}

{% macro snowflake__array(inputs) -%}
    array_construct( {{ inputs|join(' , ') }} )
{%- endmacro %}

{% macro redshift__array(inputs) -%}
    array( {{ inputs|join(' , ') }} )
{%- endmacro %}

{% macro bigquery__array(inputs) -%}
    [ {{ inputs|join(' , ') }} ]
{%- endmacro %}