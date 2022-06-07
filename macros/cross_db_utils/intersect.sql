{# This is here for backwards compatibility only #}

{% macro intersect() %}
  {{ return(adapter.dispatch('intersect', 'dbt_utils')()) }}
{% endmacro %}

{% macro default__intersect() %}
  {{ return(adapter.dispatch('intersect', 'dbt')()) }}
{% endmacro %}
