{% macro get_powers_of_two(upper_bound) %}
    {{ return(adapter.dispatch('get_powers_of_two', 'dbt_utils')(upper_bound)) }}
{% endmacro %}

{% macro default__get_powers_of_two(upper_bound) %}
    {{ return(dbt.get_powers_of_two(upper_bound)) }}
{% endmacro %}


{% macro generate_series(upper_bound) %}
    {{ return(adapter.dispatch('generate_series', 'dbt_utils')(upper_bound)) }}
{% endmacro %}

{% macro default__generate_series(upper_bound) %}
    {{ return(dbt.generate_series(upper_bound)) }}
{% endmacro %}
