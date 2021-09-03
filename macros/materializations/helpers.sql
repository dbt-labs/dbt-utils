{% macro check_for_period_filter(model_unique_id, sql) %}
    {{ return(adapter.dispatch('check_for_period_filter', 'dbt_utils')(model_unique_id, sql)) }}
{% endmacro %}

{% macro default__check_for_period_filter(model_unique_id, sql) %}
    {%- if sql.find('__PERIOD_FILTER__') == -1 -%}
        {%- set error_message -%}
        Model '{{ model_unique_id }}' does not include the required string '__PERIOD_FILTER__' in its sql
        {%- endset -%}
        {{ exceptions.raise_compiler_error(error_message) }}
    {%- endif -%}
{% endmacro %}

{% macro get_period_boundaries(target_schema, target_table, timestamp_field, start_date, stop_date, period) -%}
    {{ return(adapter.dispatch('get_period_boundaries', 'dbt_utils')(target_schema, target_table, timestamp_field, start_date, stop_date, period)) }}
{% endmacro %}

{% macro default__get_period_boundaries(target_schema, target_table, timestamp_field, start_date, stop_date, period) -%}

  {% call statement('period_boundaries', fetch_result=True) -%}
    {{ dbt_utils.log_info(model) }}
    {%- set model_name = model['name'] -%}
    
    {%- set target_schema_msg = " [DEBUG] (get_period_boundaries) target schema is: " ~ target_schema -%}
    {%- set target_table_msg = " [DEBUG] (get_period_boundaries) target table is: " ~ target_table -%}
    {%- set model_name_msg = " [DEBUG] (get_period_boundaries) model[name] is: " ~ model_name -%}
    {{ dbt_utils.log_info(target_schema_msg) }}
    {{ dbt_utils.log_info(target_table_msg) }}
    {{ dbt_utils.log_info(model_name_msg) }}
    
    with data as (
      select
          coalesce(max("{{timestamp_field}}"), '{{start_date}}')::timestamp as start_timestamp,
          coalesce(
            {{dbt_utils.dateadd('millisecond',
                                -1,
                                "nullif('" ~ stop_date ~ "','')::timestamp")}},
            {{dbt_utils.current_timestamp()}}
          ) as stop_timestamp
      from "{{target_schema}}"."{{model_name}}"
    )

    select
      start_timestamp,
      stop_timestamp,
      {{dbt_utils.datediff('start_timestamp',
                           'stop_timestamp',
                           period)}}  + 1 as num_periods
    from data
  {%- endcall %}

{%- endmacro %}

{% macro snowflake__get_period_boundaries(target_schema, target_table, timestamp_field, start_date, stop_date, period) -%}

  {% call statement('period_boundaries', fetch_result=True) -%}
    {%- set model_name = model['name'] -%}
    
    with data as (
      select
          coalesce(max({{timestamp_field}}), '{{start_date}}')::timestamp as start_timestamp,
          coalesce(
            {{dbt_utils.dateadd('millisecond',
                                -1,
                                "nullif('" ~ stop_date ~ "','')::timestamp")}},
            {{dbt_utils.current_timestamp()}}
          ) as stop_timestamp
      from {{target.schema}}.{{model_name}}
    )

    select
      start_timestamp,
      stop_timestamp,
      {{dbt_utils.datediff('start_timestamp',
                           'stop_timestamp',
                           period)}}  + 1 as num_periods
    from data
  {%- endcall %}

{%- endmacro %}


{% macro get_period_sql(target_cols_csv, sql, timestamp_field, period, start_timestamp, stop_timestamp, offset) -%}
    {{ return(adapter.dispatch('get_period_sql', 'dbt_utils')(target_cols_csv, sql, timestamp_field, period, start_timestamp, stop_timestamp, offset)) }}
{% endmacro %}

{% macro default__get_period_sql(target_cols_csv, sql, timestamp_field, period, start_timestamp, stop_timestamp, offset) -%}

  {%- set period_filter -%}
    ("{{timestamp_field}}" >  '{{start_timestamp}}'::timestamp + interval '{{offset}} {{period}}' and
     "{{timestamp_field}}" <= '{{start_timestamp}}'::timestamp + interval '{{offset}} {{period}}' + interval '1 {{period}}' and
     "{{timestamp_field}}" <  '{{stop_timestamp}}'::timestamp)
  {%- endset -%}

  {%- set filtered_sql = sql | replace("__PERIOD_FILTER__", period_filter) -%}

  select
    {{target_cols_csv}}
  from (
    {{filtered_sql}}
  ) as t -- has to have an alias

{%- endmacro %}

{% macro snowflake__get_period_sql(target_cols_csv, sql, timestamp_field, period, start_timestamp, stop_timestamp, offset) -%}

  {%- set period_filter -%}
    ({{timestamp_field}} >  '{{start_timestamp}}'::timestamp + interval '{{offset}} {{period}}' and
     {{timestamp_field}} <= '{{start_timestamp}}'::timestamp + interval '{{offset}} {{period}}' + interval '1 {{period}}' and
     {{timestamp_field}} <  '{{stop_timestamp}}'::timestamp)
  {%- endset -%}

  {%- set filtered_sql = sql | replace("__PERIOD_FILTER__", period_filter) -%}

  select
    {{target_cols_csv}}
  from (
    {{filtered_sql}}
  )

{%- endmacro %}
