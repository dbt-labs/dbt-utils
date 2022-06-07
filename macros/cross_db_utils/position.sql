{# This is here for backwards compatibility only #}

{% macro position(substring_text, string_text) -%}
    {{ return(adapter.dispatch('position', 'dbt_utils') (substring_text, string_text)) }}
{% endmacro %}

{% macro default__position(substring_text, string_text) -%}
    {{ return(adapter.dispatch('position', 'dbt') (substring_text, string_text)) }}
{% endmacro %}
