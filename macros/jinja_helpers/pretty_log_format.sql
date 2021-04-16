{% macro pretty_log_format(message) %}
    {{ return(adapter.dispatch('pretty_log_format', packages = dbt_utils._get_utils_namespaces())(message)) }}
{% endmacro %}

{% macro default__pretty_log_format(message) %}
    {{ return( dbt_utils.pretty_time() ~ ' + ' ~ message) }}
{% endmacro %}
