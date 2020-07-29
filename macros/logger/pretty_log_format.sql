{% macro pretty_log_format(message) %}

    {{ return( cc_dbt_utils.pretty_time() ~ ' + ' ~ message) }}

{% endmacro %}
