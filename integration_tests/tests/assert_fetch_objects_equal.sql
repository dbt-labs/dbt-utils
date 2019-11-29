-- depends_on: {{ ref('data_fetch') }}

{% set expected_dictionary={
    'col_1': [1, 2, 3],
    'col_2': ['a', 'b', 'c'],
    'col_3': [4.1, 5.2, none]
} %}


{% set actual_dictionary=dbt_utils.fetch(
    "select * from " ~ ref('data_fetch')
) %}

{#-
Cast the keys to lower case to handle snowflake silliness
-#}

{% set actual_dictionary_with_lower_keys={} %}
{% for key, values in actual_dictionary.items() %}
    {% do actual_dictionary_with_lower_keys.update({(key | lower): values}) %}
{% endfor %}


{% if actual_dictionary_with_lower_keys['col_1'] | map('int',default=none) | list != expected_dictionary['col_1'] %}
 {# select > 0 rows for test to fail  #}
    select 'fail 1'

{% elif actual_dictionary_with_lower_keys['col_2'] | list != expected_dictionary['col_2'] %}
 {# select > 0 rows for test to fail  #}
    select 'fail 2'

{% elif actual_dictionary_with_lower_keys['col_3'] | map('float',default=none) | list != expected_dictionary['col_3'] %}
 {# select > 0 rows for test to fail  #}
    select 'fail 3'

{% else %}
 {# select 0 rows for test to pass  #}
    select 'pass' limit 0

{% endif %}
