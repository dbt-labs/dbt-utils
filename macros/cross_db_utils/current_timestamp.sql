{% macro current_timestamp() -%}
  {% do dbt_utils.xdb_deprecation_warning_without_replacement('current_timestamp', model.package_name, model.name) %}
  {{ return(adapter.dispatch('current_timestamp_backcompat', 'dbt')()) }}
{%- endmacro %}

/* {#
    In the default case (not Snowflake or Postgres), this macro was just a passthrough to {{ dbt_utils.current_timestamp() }}.
    Now it will be a passthrough to {{ dbt.current_timestamp_in_utc() }}, which will actually
    use both {{ convert_timezone() }} + {{ dbt_utils.current_timestamp() }} to put the
    timestamp in UTC.
    
    I believe this will yield the same result, or a more correct one (!)
    -- if the current session is not in UTC -- but this needs testing.
#} */

{% macro current_timestamp_in_utc() -%}
  {% do dbt_utils.xdb_deprecation_warning_without_replacement('current_timestamp_in_utc', model.package_name, model.name) %}
  {{ return(adapter.dispatch('current_timestamp_in_utc', 'dbt')()) }}
{%- endmacro %}
