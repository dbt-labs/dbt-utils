{% macro star(from, relation_alias=False, except=[]) -%}

    {#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return('') }}
    {% endif %}

    {%- set include_cols = [] %}
    {%- set cols = adapter.get_columns_in_relation(from) -%}
    {%- for col in cols -%}

        {%- if col.column not in except -%}
            {% set _ = include_cols.append(col.column) %}

        {%- endif %}
    {%- endfor %}

    {%- for col in include_cols %}

        {% if relation_alias %} {{ relation_alias }}.{% endif %} {{ dbt_utils.identifier(col) }} {% if not loop.last %},
        {% endif %}

    {%- endfor -%}
{%- endmacro %}
