{% macro get_column_values(table, column, order_by='count(*) desc', max_records=none, default=none, where=none) -%}
    {{ return(adapter.dispatch('get_column_values', 'dbt_utils')(table, column, order_by, max_records, default, where)) }}
{% endmacro %}

{% macro default__get_column_values(table, column, order_by='count(*) desc', max_records=none, default=none, where=none) -%}
    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {% set default = [] if not default %}
        {{ return(default) }}
    {% endif %}

    {%- do dbt_utils._is_ephemeral(table, 'get_column_values') -%}

    {# Not all relations are tables. Renaming for internal clarity without breaking functionality for anyone using named arguments #}
    {# TODO: Change the method signature in a future 0.x.0 release #}
    {%- set target_relation = table -%}

    {# adapter.load_relation is a convenience wrapper to avoid building a Relation when we already have one #}
    {% set relation_exists = (load_relation(target_relation)) is not none %}

    {%- if not relation_exists and default is none -%}

        {{ exceptions.raise_compiler_error("In get_column_values(): relation " ~ target_relation ~ " does not exist and no default value was provided.") }}

    {%- elif not relation_exists and default is not none -%}

        {{ log("Relation " ~ target_relation ~ " does not exist. Returning the default value: " ~ default) }}
        {{ return(default) }}

    {%- else -%}

        {%- set query -%}
            select
                {{ column }} as value
            from {{ target_relation }}

            {% if where is not none %}
            where {{ where }}
            {% endif %}

            group by {{ column }}
            order by {{ order_by }}

            {% if max_records is not none %}
            limit {{ max_records }}
            {% endif %}
        {%- endset -%}

        {%- set value_list = run_query(query) -%}

        {%- if value_list and value_list.rows -%}
            {%- set values = value_list.columns[0].values() | list -%}
            {{ return(values) }}
        {%- else -%}
            {{ return(default) }}
        {%- endif -%}

    {%- endif -%}

{%- endmacro %}
