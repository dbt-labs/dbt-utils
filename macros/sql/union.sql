{% macro union_tables(tables, column_override=none, include=[], exclude=[], source_column_name=none) -%}

    {%- if exclude and include -%}
        {{ exceptions.raise_compiler_error("Both an exclude and include list were provided to the `union` macro. Only one is allowed") }}
    {%- endif -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('') }}
    {% endif %}

    {%- set column_override = column_override if column_override is not none else {} %}
    {%- set source_column_name = source_column_name if source_column_name is not none else '_dbt_source_relation' %}

    {%- set table_columns = {} %}
    {%- set column_superset = {} %}

    {%- for table in tables -%}

        {%- do table_columns.update({table: []}) %}

        {%- do dbt_utils._is_relation(table, 'union_tables') -%}
        {%- set cols = adapter.get_columns_in_relation(table) %}
        {%- for col in cols -%}

        {#- If an exclude list was provided and the column is in the list, do nothing #}
        {%- if exclude and col.column in exclude %}

        {#- If an include list was procided and the column is not in the list, do nothing -#}
        {%- elif include and col.column not in include %}

        {#- Otherwise add the column to the column superset #}
        {% else %}

            {# update the list of columns in this table #}
            {%- do table_columns[table].append(col.column) %}

            {%- if col.column in column_superset -%}

                {%- set stored = column_superset[col.column] %}
                {%- if col.is_string() and stored.is_string() and col.string_size() > stored.string_size() -%}

                    {%- do column_superset.update({col.column: col}) %}

                {%- endif %}

            {%- else -%}

                {%- do column_superset.update({col.column: col}) %}

            {%- endif -%}

        {%- endif -%}

        {%- endfor %}
    {%- endfor %}

    {%- set ordered_column_names = column_superset.keys() %}

    {%- for table in tables -%}

        (
            select

                cast({{ dbt_utils.string_literal(table) }} as {{ dbt_utils.type_string() }}) as {{ source_column_name }},

                {% for col_name in ordered_column_names -%}

                    {%- set col = column_superset[col_name] %}
                    {%- set col_type = column_override.get(col.column, col.data_type) %}
                    {%- set col_name = adapter.quote(col_name) if col_name in table_columns[table] else 'null' %}
                    cast({{ col_name }} as {{ col_type }}) as {{ col.quoted }} {% if not loop.last %},{% endif %}
                {%- endfor %}

            from {{ table }}
        )

        {% if not loop.last %} union all {% endif %}

    {%- endfor %}

{%- endmacro %}
