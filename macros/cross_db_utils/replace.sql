{% macro replace(field, old_chars, new_chars) -%}
    {{ return(adapter.dispatch('replace', 'dbt') (field, old_chars, new_chars)) }}
{% endmacro %}
