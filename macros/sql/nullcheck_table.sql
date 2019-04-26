{% macro nullcheck_table(relation) %}

  {% set cols = adapter.get_columns_in_relation(relation) %}

  select {{ dbt_utils.nullcheck(cols) }}
  from {{relation}}
  
{% endmacro %}
