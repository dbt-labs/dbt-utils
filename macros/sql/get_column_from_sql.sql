{% macro get_column_from_sql(sql, column_name) %}
    {{ return(dbt_utils.fetch(sql)[column_name]) }}
{% endmacro %}