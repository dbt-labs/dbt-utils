{% macro _is_relation(arg, macro) %}
    {%- if execute and arg.name is none -%}
        {%- do exceptions.raise_compiler_error("Macro " ~ macro ~ " expected a Relation but received the value: " ~ arg) -%}
    {%- endif -%}
{% endmacro %}
