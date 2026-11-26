
{% test is_constant(model, column_name, group_by_columns = [], value = none, quote = True) %}
  {{ return(adapter.dispatch('test_is_constant', 'dbt_utils')(model, column_name, group_by_columns, value, quote)) }}
{% endtest %}


{% macro default__test_is_constant(model, column_name, group_by_columns, value, quote) %}

{% if group_by_columns|length() > 0 %}
  {% set select_gb_cols = group_by_columns|join(', ') + ', ' %}
  {% set groupby_gb_cols = 'group by ' + group_by_columns|join(', ') %}
{% endif %}

{% if value is none %}

  {# Asserts that all rows share a single value, optionally within each group. #}
  {# Returns the groups (or the whole table) where more than one distinct #}
  {# value was found. #}
  select
      {# In TSQL, subquery aggregate columns need aliases #}
      {# thus: a filler col name, 'filler_column' #}
      {{ select_gb_cols }}
      count(distinct {{ column_name }}) as filler_column

  from {{ model }}

    {{ groupby_gb_cols }}

  having count(distinct {{ column_name }}) > 1

{% else %}

  {# Asserts that every row equals the given value. Returns the offending rows. #}
  {# Nulls are not flagged; pair with not_null when nulls should fail. #}
  {% if quote %}
    {% set rendered_value = "'" ~ value ~ "'" %}
  {% else %}
    {% set rendered_value = value %}
  {% endif %}

  select
      {{ select_gb_cols }}
      {{ column_name }}

  from {{ model }}

  where not {{ column_name }} = {{ rendered_value }}

{% endif %}

{% endmacro %}
