{% macro get_column_from_sql(sql, column_name) %}

{% if execute %}
    {{ return(dbt_utils.fetch(sql)[column_name]) }}
{% else %}
    {{return([])}}
{% endif %}

{% endmacro %}