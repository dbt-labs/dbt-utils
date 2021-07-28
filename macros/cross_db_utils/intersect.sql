{% macro intersect() %}
  {{ return(adapter.dispatch('intersect', 'cc_dbt_utils')()) }}
{% endmacro %}


{% macro default__intersect() %}

    intersect

{% endmacro %}

{% macro bigquery__intersect() %}

    intersect distinct

{% endmacro %}
