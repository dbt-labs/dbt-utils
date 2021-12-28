{% macro my_custom_macro() %}
    whatever
{% endmacro %}

{% macro limit_zero() %}
    {{ return(adapter.dispatch('limit_zero', 'cc_dbt_utils')()) }}
{% endmacro %}

{% macro default__limit_zero() %}
    {{ return('limit 0') }}
{% endmacro %}