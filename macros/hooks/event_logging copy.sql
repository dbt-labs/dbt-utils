{% macro get_audit_schema() %}

    {%- if target.name in ['prod', 'uat'] -%}
        {{ return('dbt_logging') }}      
    {%- else -%}
        {{ return(target.schema~'_dbt_logging') }}
    {%- endif -%}

{% endmacro %}

{% macro get_audit_relation() %}

    {%- set audit_schema=cc_dbt_utils.get_audit_schema() -%}

    {%- set audit_table =
        api.Relation.create(
            database=target.database,
            schema=audit_schema,
            identifier='dbt_audit_log_raw_v2',
            type='table'
        ) -%}

    {{ return(audit_table) }}

{% endmacro %}

{% macro log_audit_event(event_data, event_timestamp, invocation_id) %}

    insert into {{ cc_dbt_utils.get_audit_relation() }} (
        event_data,
        event_timestamp,
        invocation_id
    )

    values (
        '{{ event_data }}',
        {{ cc_dbt_utils.current_timestamp_in_utc() }},
        '{{ invocation_id }}'
    );
    		{% do log('post insert', True) %}

{% endmacro %}


{% macro create_audit_schema() %}
    create schema if not exists {{ cc_dbt_utils.get_audit_schema() }}
{% endmacro %}


{% macro create_audit_log_table() %}

    create table if not exists {{ cc_dbt_utils.get_audit_relation() }}
    (
       event_data            varchar(16777216),
       event_timestamp  {{ dbt_utils.type_timestamp() }},
       invocation_id    varchar(512)
    )

{% endmacro %}


{% macro log_run_end_event(results, flags, target) %}
    {% set run_audit=cc_dbt_utils.get_run_audit(results, flags, target) %}
    
    {{ cc_dbt_utils.log_audit_event(run_audit) }}

    {% do log('pre commit', True) %}
    
    commit;
    
    {% do log('post commit', True) %}

    {% do log('finish audit log event', True) %}

{% endmacro %}
