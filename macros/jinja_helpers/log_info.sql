{% macro log_info(message) %}
    {{ return(adapter.dispatch('log_info', packages = dbt_utils._get_utils_namespaces())(message)) }}
{% endmacro %}

{% macro default__log_info(message) %}
    {{ log(dbt_utils.pretty_log_format(message), info=True) }}
{% endmacro %}
