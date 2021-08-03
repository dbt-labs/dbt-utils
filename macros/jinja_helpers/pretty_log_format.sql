{% macro pretty_log_format(message) %}
    {{ return(adapter.dispatch('pretty_log_format', 'cc_dbt_utils')(message)) }}
{% endmacro %}

{% macro default__pretty_log_format(message) %}
    {{ return( cc_dbt_utils.pretty_time() ~ ' + ' ~ message) }}
{% endmacro %}
