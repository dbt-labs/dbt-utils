{% macro date_trunc(datepart, date) %}
  {{ adapter_macro('dbt_utils.date_trunc', datepart, date) }}
{% endmacro %}

{% macro default__date_trunc(datepart, date) %}
    date_trunc('{{datepart}}', {{date}})
{% endmacro %}

{% macro bigquery__date_trunc(datepart, date) %}
    date_trunc({{date}}, {{datepart}})
{% endmacro %}
