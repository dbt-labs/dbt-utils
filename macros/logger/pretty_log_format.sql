{% macro pretty_log_format(message) %}

    {{ return( pretty_time() ~ ' + ' ~ message) }}

{% endmacro %}
