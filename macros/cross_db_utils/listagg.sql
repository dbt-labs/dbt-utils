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

{# if there are instances of delimiter_text within your measure, you cannot include a limit_num #}
{% macro redshift__listagg(measure, delimiter_text, order_by_clause, limit_num) -%}

    {% if limit_num -%}
    regexp_replace(
        regexp_replace(
            regexp_replace(
                json_serialize(
                    subarray(
                        split_to_array(
                            listagg(
                                {{ measure }},
                                {{ delimiter_text }}
                                )
                                {% if order_by_clause -%}
                                within group ({{ order_by_clause }})
                                {%- endif %}
                            ,{{ delimiter_text }}
                        ),
                        0,
                        {{ limit_num }}
                    )
                ),
                '^\\[\"?',
                ''
            ),
            '"?"\\]$',
            ''
        ),
        '"?,{1}"?',
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