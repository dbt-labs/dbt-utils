{% macro intersect() %}
  {{ return(adapter.dispatch('intersect', 'dbt')()) }}
{% endmacro %}
