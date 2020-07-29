{% macro replace(field, old_chars, new_chars) -%}
    {{ adapter_macro('cc_dbt_utils.replace', field, old_chars, new_chars) }}
{% endmacro %}


{% macro default__replace(field, old_chars, new_chars) %}

    replace(
        {{ field }},
        {{ old_chars }},
        {{ new_chars }}
    )
    

{% endmacro %}