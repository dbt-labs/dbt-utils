{% macro pretty_time(format='%H:%M:%S') %}
    {{ return(adapter.dispatch('pretty_time', packages = dbt_utils._get_utils_namespaces())(format='%H:%M:%S')) }}
{% endmacro %}

{% macro default__pretty_time(format='%H:%M:%S') %}
    {{ return(modules.datetime.datetime.now().strftime(format)) }}
{% endmacro %}
