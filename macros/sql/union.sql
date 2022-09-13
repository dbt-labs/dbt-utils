{%- macro union_relations(relations, column_override=none, include=[], exclude=[], source_column_name='_dbt_source_relation', where=none) -%}
    {{ return(adapter.dispatch('union_relations', 'dbt_utils')(relations, column_override, include, exclude, source_column_name, where)) }}
{% endmacro %}

{%- macro default__union_relations(relations, column_override=none, include=[], exclude=[], source_column_name='_dbt_source_relation', where=none) -%}

    {%- if exclude and include -%}
        {{ exceptions.raise_compiler_error("Both an exclude and include list were provided to the `union` macro. Only one is allowed") }}
    {%- endif -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. -#}
    {%- if not execute %}
        {{ return('') }}
    {% endif -%}

    {%- set column_override = column_override if column_override is not none else {} -%}

    {%- set relation_columns = {} -%}
    {%- set column_superset = {} -%}

    {%- for relation in relations -%}

        {%- do relation_columns.update({relation: []}) -%}

        {%- do dbt_utils._is_relation(relation, 'union_relations') -%}
        {%- do dbt_utils._is_ephemeral(relation, 'union_relations') -%}
        {%- set cols = adapter.get_columns_in_relation(relation) -%}
        {%- for col in cols -%}

        {#- If an exclude list was provided and the column is in the list, do nothing -#}
        {%- if exclude and col.column in exclude -%}

        {#- If an include list was provided and the column is not in the list, do nothing -#}
        {%- elif include and col.column not in include -%}

        {#- Otherwise add the column to the column superset -#}
        {%- else -%}

            {#- update the list of columns in this relation -#}
            {%- do relation_columns[relation].append(col.column) -%}

            {%- if col.column in column_superset -%}

                {%- set stored = column_superset[col.column] -%}
                {%- if col.is_string() and stored.is_string() and col.string_size() > stored.string_size() -%}

                    {%- do column_superset.update({col.column: col}) -%}

                {%- endif %}

            {%- else -%}

                {%- do column_superset.update({col.column: col}) -%}

            {%- endif -%}

        {%- endif -%}

        {%- endfor -%}
    {%- endfor -%}

    {%- set ordered_column_names = column_superset.keys() -%}
    {%- set dbt_command = flags.WHICH -%}


    {% if dbt_command in ['run', 'build'] %}
    {% if (include | length > 0 or exclude | length > 0) and not column_superset.keys() %}
        {%- set relations_string -%}
            {%- for relation in relations -%}
                {{ relation.name }}
            {%- if not loop.last %}, {% endif -%}
            {%- endfor -%}
        {%- endset -%}

        {%- set error_message -%}
            There were no columns found to union for relations {{ relations_string }}
        {%- endset -%}

        {{ exceptions.raise_compiler_error(error_message) }}
    {%- endif -%}
    {%- endif -%}

    {%- for relation in relations %}

        (
            select

                {%- if source_column_name is not none %}
                cast({{ string_literal(relation) }} as {{ type_string() }}) as {{ source_column_name }},
                {%- endif %}

                {% for col_name in ordered_column_names -%}

                    {%- set col = column_superset[col_name] %}
                    {%- set col_type = column_override.get(col.column, col.data_type) %}
                    {%- set col_name = adapter.quote(col_name) if col_name in relation_columns[relation] else 'null' %}
                    cast({{ col_name }} as {{ col_type }}) as {{ col.quoted }} {% if not loop.last %},{% endif -%}

                {%- endfor %}

            from {{ relation }}

            {% if where -%}
            where {{ where }}
            {%- endif %}
        )

        {% if not loop.last -%}
            union all
        {% endif -%}

    {%- endfor -%}

{%- endmacro -%}
