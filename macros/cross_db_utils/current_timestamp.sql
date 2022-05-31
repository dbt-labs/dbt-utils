{% macro current_timestamp() -%}
  {{ return(adapter.dispatch('current_timestamp', 'dbt')()) }}
{%- endmacro %}

{% macro current_timestamp_in_utc() -%}
  {{ return(adapter.dispatch('current_timestamp_in_utc', 'dbt')()) }}
{%- endmacro %}

{% macro current_timestamp__original() -%}
  {{ return(adapter.dispatch('current_timestamp__original', 'dbt_utils')()) }}
{%- endmacro %}

{% macro default__current_timestamp__original() %}
    current_timestamp::{{dbt_utils.type_timestamp()}}
{% endmacro %}

{% macro redshift__current_timestamp__original() %}
    getdate()
{% endmacro %}

{% macro bigquery__current_timestamp__original() %}
    current_timestamp
{% endmacro %}
