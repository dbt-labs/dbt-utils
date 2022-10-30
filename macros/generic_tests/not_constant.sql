
{% test not_constant(model, column_name, group_by_columns = []) %}
  {{ return(adapter.dispatch('test_not_constant', 'dbt_utils')(model, column_name, group_by_columns)) }}
{% endtest %}

{% macro default__test_not_constant(model, column_name, group_by_columns) %}

{% if group_by_columns|length() > 0 %}
  {% set select_gb_cols = group_by_columns|join(' ,') + ', ' %}
  {% set groupby_gb_cols = 'group by ' + group_by_columns|join(',') %}
{% endif %}


select
    {# In TSQL, subquery aggregate columns need aliases #}
    {# thus: a filler col name, 'filler_column' #}
    {{select_gb_cols}}
    count(distinct {{ column_name }}) as filler_column

from {{ model }}

  {{groupby_gb_cols}}

having count(distinct {{ column_name }}) = 1


{% endmacro %}
