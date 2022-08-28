{% macro current_timestamp() -%}
  {% do dbt_utils.xdb_deprecation_warning_without_replacement('current_timestamp', model.package_name, model.name) %}
  {{ return(adapter.dispatch('current_timestamp', 'dbt_utils')()) }}
{%- endmacro %}

{% macro default__current_timestamp() %}
    current_timestamp::{{ type_timestamp() }}
{% endmacro %}

{% macro redshift__current_timestamp() %}
    getdate()
{% endmacro %}

{% macro bigquery__current_timestamp() %}
    current_timestamp
{% endmacro %}



{% macro current_timestamp_in_utc() -%}
  {% do dbt_utils.xdb_deprecation_warning_without_replacement('current_timestamp_in_utc', model.package_name, model.name) %}
  {{ return(adapter.dispatch('current_timestamp_in_utc', 'dbt_utils')()) }}
{%- endmacro %}

{% macro default__current_timestamp_in_utc() %}
    {{ dbt_utils.current_timestamp() }}
{% endmacro %}

{% macro snowflake__current_timestamp_in_utc() %}
    convert_timezone('UTC', {{ dbt_utils.current_timestamp() }})::{{ type_timestamp() }}
{% endmacro %}

{% macro postgres__current_timestamp_in_utc() %}
    (current_timestamp at time zone 'utc')::{{ type_timestamp() }}
{% endmacro %}

{# redshift should use default instead of postgres #}
{% macro redshift__current_timestamp_in_utc() %}
    {{ return(dbt_utils.default__current_timestamp_in_utc()) }}
{% endmacro %}
