{% macro get_audit_schema() %}
    {{{{ return(adapter.dispatch('get_audit_schema', 'cc_dbt_utilis')()) }}}}
{% endmacro %}

{% macro default__get_audit_schema() %}

    {%- if target.name in ['prod', 'uat'] -%}
        {{ return('dbt_logging') }}      
    {%- else -%}
        {{ return(target.schema~'_dbt_logging') }}
    {%- endif -%}

{% endmacro %}

{% macro get_audit_relation() %}
    {{{{ return(adapter.dispatch('get_audit_relation', 'cc_dbt_utilis')()) }}}}
{% endmacro %}

{% macro default__get_audit_relation() %}

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


{% macro log_audit_event(event_data, created_at) %}
    {{{{ return(adapter.dispatch('log_audit_event', 'cc_dbt_utilis')(event_data, created_at)) }}}}
{% endmacro %}

{% macro default__log_audit_event(event_data, created_at) %}

    insert into {{ cc_dbt_utils.get_audit_relation() }} (
        event_data,
        created_at
    )

    values (
        {% if variable != None %}'{{ event_data }}'{% else %}null::varchar(16777216){% endif %},
        {{ cc_dbt_utils.current_timestamp_in_utc() }}
        
    );

    commit;


{% endmacro %}


{% macro create_audit_schema() %}
    {{{{ return(adapter.dispatch('create_audit_schema', 'cc_dbt_utilis')()) }}}}
{% endmacro %}

{% macro default__create_audit_schema() %}
    create schema if not exists {{ cc_dbt_utils.get_audit_schema() }}
{% endmacro %}


{% macro create_audit_log_table() %}
    {{{{ return(adapter.dispatch('create_audit_log_table', 'cc_dbt_utilis')()) }}}}
{% endmacro %}

{% macro default__create_audit_log_table() %}

    {% set required_columns = [
       ["event_data", "varchar(16777216)"],
       ["created_at", cc_dbt_utils.type_timestamp()]
    
    ] -%}

    {% set audit_table = cc_dbt_utils.get_audit_relation() -%}

    {% set audit_table_exists = adapter.get_relation(audit_table.database, audit_table.schema, audit_table.name) -%}


    {% if audit_table_exists -%}

        {%- set columns_to_create = [] -%}

        {# map to lower to cater for snowflake returning column names as upper case #}
        {%- set existing_columns = adapter.get_columns_in_relation(audit_table)|map(attribute='column')|map('lower')|list -%}

        {%- for required_column in required_columns -%}
            {%- if required_column[0] not in existing_columns -%}
                {%- do columns_to_create.append(required_column) -%}

            {%- endif -%}
        {%- endfor -%}


        {%- for column in columns_to_create -%}
            alter table {{ audit_table }}
            add column {{ column[0] }} {{ column[1] }}
            default null;
        {% endfor -%}

        {%- if columns_to_create|length > 0 %}
            commit;
        {% endif -%}

    {%- else -%}
        create table if not exists {{ audit_table }}
        (
        {% for column in required_columns %}
            {{ column[0] }} {{ column[1] }}{% if not loop.last %},{% endif %}
        {% endfor %}
        )
    {%- endif -%}

{% endmacro -%}


{% macro log_run_end_event(results, flags, target) %}
    {{{{ return(adapter.dispatch('log_run_end_event', 'cc_dbt_utilis')(results, flags, target)) }}}}
{% endmacro %}

{% macro default_log_run_end_event(results, flags, target) %}
    {% set run_audit=cc_dbt_utils.get_run_audit(results, flags, target) %}
    
    {{ cc_dbt_utils.log_audit_event(run_audit) }}

    commit;
    
{% endmacro %}