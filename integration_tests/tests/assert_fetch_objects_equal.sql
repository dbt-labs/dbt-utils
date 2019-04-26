-- depends_on: {{ ref('data_fetch') }}

{% set expected_dictionary={
    'col_1': (1, 2, 3),
    'col_2': ('a', 'b', 'c'),
    'col_3': (4.0, 5.0, none)
} %}

{% set actual_dictionary=dbt_utils.fetch(
    "select * from {{ ref('data_fetch') }}"
) %}
{% if actual_dictionary == expected_dictionary %}
    {# Return 0 rows for the test to pass #}
    select 1 where false
{% else %}
    {# Return >0 rows for the test to fail #}
    select 1
{% endif %}
