{% macro _is_ephemeral(obj, macro) %}
    {%- if obj.is_cte -%}
        {% if obj.name.startswith('__dbt__CTE__') %}
            {% set model_name = obj.name[12:] %}
        {% else %}
            {% set model_name = obj.name %}
        {%- endif -%}
        {% set error_message %}
The `{{ macro }}` macro cannot be used with ephemeral models, as it relies on the information schema.

`{{ model_name }}` is an ephemeral model. Consider making it a view or table instead.
        {% endset %}
        {%- do exceptions.raise_compiler_error(error_message) -%}
    {%- endif -%}
{% endmacro %}
