{% macro escape_single_quotes(expression) %}
      {{ return(adapter.dispatch('escape_single_quotes', 'dbt_utils') (expression)) }}
{% endmacro %}

{% macro default__escape_single_quotes(expression) -%}
{{ expression | replace("'","''") }}
{%- endmacro %}

{% macro snowflake__escape_single_quotes(expression) -%}
{{ expression | replace("'", "\\'") }}
{%- endmacro %}

{% macro bigquery__escape_single_quotes(expression) -%}
{{ expression | replace("'", "\\'") }}
{%- endmacro %}
