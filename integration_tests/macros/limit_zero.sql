{% macro limit_zero() %}
    {{ return(adapter.dispatch('limit_zero', dbt_utils._get_utils_namespaces())()) }}
{% endmacro %}

{% macro default__limit_zero() %}
    {{ return('limit 0') }}
{% endmacro %}