{% macro log_info(message) %}
    {{ adapter.dispatch('log_info', packages = dbt_utils._get_utils_namespaces())(message) }}
{% endmacro %}

{% macro default__log_info(message) %}
    {{ log(pretty_log_format(message), info=True) }}
{% endmacro %}
