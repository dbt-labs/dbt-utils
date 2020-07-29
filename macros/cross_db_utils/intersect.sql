{% macro intersect() %}
  {{ adapter_macro('cc_dbt_utils.intersect') }}
{% endmacro %}


{% macro default__intersect() %}

    intersect

{% endmacro %}

{% macro bigquery__intersect() %}

    intersect distinct

{% endmacro %}
