{% macro log_info(message) %}

    {{ log(pretty_log_format(message), info=True) }}

{% endmacro %}
