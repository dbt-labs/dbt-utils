{# This is here for backwards compatibility only #}

{% macro length(expression) -%}
    {{ return(adapter.dispatch('length', 'dbt_utils') (expression)) }}
{% endmacro %}

{% macro default__length(expression) -%}
    {{ return(adapter.dispatch('length', 'dbt') (expression)) }}
{% endmacro %}
