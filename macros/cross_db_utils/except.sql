{% macro except() %}
  {{ return(adapter.dispatch('except', 'dbt')()) }}
{% endmacro %}
