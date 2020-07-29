{% macro current_timestamp() -%}
  {{ adapter_macro('cc_dbt_utils.current_timestamp') }}
{%- endmacro %}

{% macro default__current_timestamp() %}
    current_timestamp::{{cc_dbt_utils.type_timestamp()}}
{% endmacro %}

{% macro redshift__current_timestamp() %}
    getdate()
{% endmacro %}

{% macro bigquery__current_timestamp() %}
    current_timestamp
{% endmacro %}



{% macro current_timestamp_in_utc() -%}
  {{ adapter_macro('cc_dbt_utils.current_timestamp_in_utc') }}
{%- endmacro %}

{% macro default__current_timestamp_in_utc() %}
    {{cc_dbt_utils.current_timestamp()}}
{% endmacro %}

{% macro snowflake__current_timestamp_in_utc() %}
    convert_timezone('UTC', {{cc_dbt_utils.current_timestamp()}})::{{cc_dbt_utils.type_timestamp()}}
{% endmacro %}

{% macro postgres__current_timestamp_in_utc() %}
    (current_timestamp at time zone 'utc')::{{cc_dbt_utils.type_timestamp()}}
{% endmacro %}
