{% macro star(from=none, except=[]) -%}
    {%- if from is not none -%}
        {%- set table_parts = (from | string | replace('"', '')).split('.') %}
        {%- set include_cols = [] %}
        {%- set cols = adapter.get_columns_in_table(*table_parts) %}
        {%- for col in cols -%}
            {%- if col.column not in except -%}
                {% set _ = include_cols.append(col.column) %}
            {%- endif %}
        {%- endfor %}

        {%- for col in include_cols %}
            "{{ col }}" {% if not loop.last %},
            {% endif %}
        {%- endfor -%}
    {%- else -%}
        *
    {%- endif -%}
{%- endmacro %}
