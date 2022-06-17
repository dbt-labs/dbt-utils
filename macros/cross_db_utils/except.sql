{# This is here for backwards compatibility only #}

{% macro except() %}
  {{ return(adapter.dispatch('except', 'dbt_utils')()) }}
{% endmacro %}

{% macro default__except() %}
  {{ return(adapter.dispatch('except', 'dbt')()) }}
{% endmacro %}
