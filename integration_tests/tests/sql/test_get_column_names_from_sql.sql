
{% set expected_columns=('col_a', 'col_b') %}


{% if target.type in ('snowflake') %}
    {% do expected_columns.upper() %}
{% endif %}

{% set query_sql="select 1 as col_a, 2 as col_b limit 1" %}

{% set actual_columns=dbt_utils.get_column_names_from_sql(query_sql) %}

{% if actual_columns == expected_columns %}
select 1 limit 0
{% else %}
select 1
{% endif %}
