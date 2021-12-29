{% test unique_where(model, column_name) %}
  {%- set deprecation_warning = '
    Warning: `cc_dbt_utils.unique_where` is no longer supported.
    Starting in dbt v0.20.0, the built-in `unique` test supports a `where` config.
    ' -%}
  {%- do exceptions.warn(deprecation_warning) -%}
  {{ return(adapter.dispatch('test_unique_where', 'cc_dbt_utils')(model, column_name)) }}
{% endtest %}

{% macro default__test_unique_where(model, column_name) %}
  {{ return(test_unique(model, column_name)) }}
{% endmacro %}
