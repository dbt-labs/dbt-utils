-- depends_on: {{ ref('data_fetch') }}

{% set expected_dictionary={
    'col_1': [1, 2, 3],
    'col_2': ['a', 'b', 'c'],
    'col_3': [4.0, 5.0, none]
} %}

{% set actual_dictionary=dbt_utils.fetch(
    "select * from " ~ ref('data_fetch')
) %}

{% if target.type == 'snowflake' %}

{% if actual_dictionary['COL_1'] | map('int',default=none) | list != expected_dictionary['col_1'] %}
 {# select > 0 rows for test to fail  #}
    select 1

{% elif actual_dictionary['COL_2'] | list != expected_dictionary['col_2']%}
 {# select > 0 rows for test to fail  #}
    select 1

{% elif actual_dictionary['COL_3'] | map('float',default=none) | list != expected_dictionary['col_3'] %}
 {# select > 0 rows for test to fail  #}
    select 1

{% else %}
 {# select 0 rows for test to pass  #}
    select 1 limit 0

{% endif %}

{% else %}

{% if actual_dictionary['col_1'] | map('int',default=none) | list != expected_dictionary['col_1'] %}
 {# select > 0 rows for test to fail  #}
    select 1

{% elif actual_dictionary['col_2'] | list != expected_dictionary['col_2']%}
 {# select > 0 rows for test to fail  #}
    select 1

{% elif actual_dictionary['col_3']  | list != expected_dictionary['col_3'] %}
 {# select > 0 rows for test to fail  #}
    select 1

{% else %}
 {# select 0 rows for test to pass  #}
    select 1 limit 0

{% endif %}

{% endif %}
