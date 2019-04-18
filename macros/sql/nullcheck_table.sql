{% macro nullcheck_table(schema, table) %}

  {% set cols = adapter.get_columns_in_relation(this)) %}

  select {{ dbt_utils.nullcheck(cols) }}
  from {{schema}}.{{table}}

{% endmacro %}
