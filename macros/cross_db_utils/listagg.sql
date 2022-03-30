{% macro listagg(measure, delimiter_text="','", order_by_clause=none, limit_num=none) -%}
    {{ return(adapter.dispatch('listagg', 'dbt_utils') (measure, delimiter_text, order_by_clause, limit_num)) }}
{%- endmacro %}

{% macro default__listagg(measure, delimiter_text, order_by_clause, limit_num) -%}

    {% if limit_num -%}
    array_to_string(
        array_slice(
            array_agg(
                {{ measure }}
            ){% if order_by_clause -%}
            within group ({{ order_by_clause }})
            {%- endif %}
            ,0
            ,{{ limit_num }}
        ),
        {{ delimiter_text }}
        )
    {%- else %}
    listagg(
        {{ measure }},
        {{ delimiter_text }}
        )
        {% if order_by_clause -%}
        within group ({{ order_by_clause }})
        {%- endif %}
    {%- endif %}

{%- endmacro %}

{% macro bigquery__listagg(measure, delimiter_text, order_by_clause, limit_num) -%}

    string_agg(
        {{ measure }},
        {{ delimiter_text }}
        {% if order_by_clause -%}
        {{ order_by_clause }}
        {%- endif %}
        {% if limit_num -%}
        limit {{ limit_num }}
        {%- endif %}
        )

{%- endmacro %}

{% macro postgres__listagg(measure, delimiter_text, order_by_clause, limit_num) -%}
    
    {% if limit_num -%}
    array_to_string(
        (array_agg(
            {{ measure }}
            {% if order_by_clause -%}
            {{ order_by_clause }}
            {%- endif %}
        ))[1:{{ limit_num }}],
        {{ delimiter_text }}
        )
    {%- else %}
    string_agg(
        {{ measure }},
        {{ delimiter_text }}
        {% if order_by_clause -%}
        {{ order_by_clause }}
        {%- endif %}
        )
    {%- endif %}

{%- endmacro %}

{# if there are instances of ',' within your measure, you cannot include a limit_num #}
{% macro snowflake__listagg(measure, delimiter_text, order_by_clause, limit_num) -%}

    {% if limit_num -%}
    {% set delimiter_text = delimiter_text|replace("'","") %}
    {% set regex %}'([^{{ delimiter_text }}]+{{ delimiter_text }}){1,{{ limit_num - 1}}}[^{{ delimiter_text }}]+'{% endset %}
    regexp_replace(
        listagg(
            {{ measure }},
            {{ delimiter_text }}
            )
            {% if order_by_clause -%}
            within group ({{ order_by_clause }})
            {%- endif %}
        ,{{ regex }}
        )
    {%- else %}
    listagg(
        {{ measure }},
        {{ delimiter_text }}
        )
        {% if order_by_clause -%}
        within group ({{ order_by_clause }})
        {%- endif %}
    {%- endif %}

{%- endmacro %}