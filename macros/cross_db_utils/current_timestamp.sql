{# This is here for backwards compatibility only #}

{% macro current_timestamp() -%}
  {{ return(adapter.dispatch('current_timestamp', 'dbt_utils')()) }}
{%- endmacro %}

{% macro default__current_timestamp() -%}
  {{ return(adapter.dispatch('current_timestamp', 'dbt')()) }}
{%- endmacro %}

{% macro current_timestamp_in_utc() -%}
  {{ return(adapter.dispatch('current_timestamp_in_utc', 'dbt_utils')()) }}
{%- endmacro %}

{% macro default__current_timestamp_in_utc() -%}
  {{ return(adapter.dispatch('current_timestamp_in_utc', 'dbt')()) }}
{%- endmacro %}
