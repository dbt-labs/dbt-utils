-- depends_on: {{ ref('data_get_column_from_sql') }}

{% set expected_col_a = (1,2,3.0,None) %}
{% set expected_col_b = ('a','b','c','d') %}

{% set get_col_a = dbt_utils.get_column_from_sql(
    'select * from {{ ref(\'data_get_column_from_sql\') }}',
    'col_a'
)%}
{% set get_col_b = dbt_utils.get_column_from_sql(
    'select * from {{ ref(\'data_get_column_from_sql\') }}',
    'col_b'
)%}

{% if get_col_a == expected_col_a and get_col_b == expected_col_b%}
    {# Return 0 rows for the test to pass #}
    select 1 where false
{% else %}
    {# Return >0 rows for the test to fail #}
    select 1
{% endif %}