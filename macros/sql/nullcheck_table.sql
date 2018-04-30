{% macro nullcheck_table(schema, table) %}

  {% set source = api.Relation.create(schema=schema, identifier=table) %}
  {% set cols = adapter.get_columns_in_table(schema, table) %}

  select {{ dbt_utils.nullcheck(cols) }}
  from {{ source }}
  
{% endmacro %}
