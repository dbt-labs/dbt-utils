{% macro _is_ephemeral(obj, macro) %}
    {%- if obj.is_cte -%}
        {% set error_message %}
The `{{ macro }}` macro cannot be used with ephemeral models, as it relies on the information schema.

`{{ obj.name }}` is an ephemeral model. Consider making is a view or table instead.
        {% endset %}
        {%- do exceptions.raise_compiler_error(error_message) -%}
    {%- endif -%}
{% endmacro %}
