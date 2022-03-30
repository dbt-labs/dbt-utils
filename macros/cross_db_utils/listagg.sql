{% macro listagg(measure, delimiter_text=none, order_by_clause=none, limit_num=none, group_by_col=none) -%}
  {{ return(adapter.dispatch('listagg', 'dbt_utils') (measure, delimiter_text, order_by_clause, limit_num, group_by_col)) }}
{%- endmacro %}


{% macro default__listagg(measure, delimiter_text, order_by_clause, limit_num, group_by_col) -%}

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
        )
        {% if delimiter_text -%}
        ,{{ delimiter_text }}
        {%- else %}
        ,''
        {%- endif %}
        )
    {%- else %}
    listagg(
        {{ measure }}
        {% if delimiter_text -%}
        ,{{ delimiter_text }}
        {%- endif %}
        )
        {% if order_by_clause -%}
        within group ({{ order_by_clause }})
        {%- endif %}
    {%- endif %}

{%- endmacro %}

{% macro bigquery__listagg(measure, delimiter_text, order_by_clause, limit_num, group_by_col) -%}

    string_agg(
        {{ measure }}
        {% if delimiter_text -%}
        ,{{ delimiter_text }}
        {%- endif %}
        {% if order_by_clause -%}
        {{ order_by_clause }}
        {%- endif %}
        {% if limit_num -%}
        limit {{ limit_num }}
        {%- endif %}
        )

{%- endmacro %}

{# in postgres if you must supply a delimiter_text #}
{% macro postgres__listagg(measure, delimiter_text, order_by_clause, limit_num, group_by_col) -%}
    
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

{# in redshift if you supply a limit_num you must also supply a group_by_col #}
{% macro redshift__listagg(measure, delimiter_text, order_by_clause, limit_num, group_by_col) -%}

    {% if limit_num and group_by_col -%}
    listagg( -- what about distinct?
        (
            case when row_number() over (partition by {{ group_by_col }} {% if order_by_clause %} {{ order_by_clause }} {% endif %}) <= {{ limit_num }} then {{ measure }} end
        )
        {% if delimiter_text -%}
        ,{{ delimiter_text }}
        {%- endif %}
        )
        {% if order_by_clause -%}
        within group ({{ order_by_clause }})
        {%- endif %}
    {%- else %}
    listagg(
        {{ measure }}
        {% if delimiter_text -%}
        ,{{ delimiter_text }}
        {%- endif %}
        )
        {% if order_by_clause -%}
        within group ({{ order_by_clause }})
        {%- endif %}
    {%- endif %}

{%- endmacro %}