{% macro position(substring, string_text) -%}
    {{ adapter_macro('dbt_utils.position', substring, string_text) }}
{% endmacro %}


{% macro default__position(substring, string_text) %}

    position(
        {{ substring }} in {{ string_text }}
    )
    
{%- endmacro -%}
