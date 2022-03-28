{% macro listagg(measure, delimiter_text, order_by_clause='', limit_clause='') -%}
  {{ return(adapter.dispatch('listagg', 'dbt_utils') (measure, delimiter_text, order_by_clause, limit_clause)) }}
{%- endmacro %}


{% macro default__listagg(measure, delimiter_text, order_by_clause, limit_clause) -%}

    listagg(
        {{ measure }},
        {{ delimiter_text }}
        )
        {% if order_by_clause -%}
        within group ({{ order_by_clause }})
        {%- endif %}

{%- endmacro %}

{% macro bigquery__listagg(measure, delimiter_text, order_by_clause, limit_clause) -%}

    string_agg(
        {{ measure }},
        {{ delimiter_text }}
        {% if order_by_clause -%}
        {{ order_by_clause }}
        {%- endif %}
        {% if limit_clause -%}
        {{ limit_clause }}
        {%- endif %}
        )

{%- endmacro %}

{% macro postgres__listagg(measure, delimiter_text, order_by_clause, limit_clause) -%}

    string_agg(
        {{ measure }},
        {{ delimiter_text }}
        {% if order_by_clause -%}
        {{ order_by_clause }}
        {%- endif %}
        )

{%- endmacro %}

{# redshift should use default instead of postgres #}
{% macro redshift__listagg(measure, delimiter_text, order_by_clause, limit_clause) -%}

    {{ return(dbt_utils.default__listagg(measure, delimiter_text, order_by_clause, limit_clause)) }}

{%- endmacro %}