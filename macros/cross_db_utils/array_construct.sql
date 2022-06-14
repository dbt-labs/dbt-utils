{% macro array_construct(inputs = [], data_type = 'varchar') -%}
  {{ return(adapter.dispatch('array_construct', 'dbt_utils')(inputs)) }}
{%- endmacro %}

{# all inputs must be the same data type to match postgres functionality #}
{% macro default__array_construct(inputs) -%}
    {% if input|length > 0 %}
    array[ {{ inputs|join(' , ') }} ]
    {% else %}
    array[]::{{data_type}}[]
    {% endif %}
{%- endmacro %}

{% macro snowflake__array_construct(inputs) -%}
    array_construct( {{ inputs|join(' , ') }} )
{%- endmacro %}

{% macro redshift__array_construct(inputs) -%}
    array( {{ inputs|join(' , ') }} )
{%- endmacro %}

{% macro bigquery__array_construct(inputs) -%}
    [ {{ inputs|join(' , ') }} ]
{%- endmacro %}