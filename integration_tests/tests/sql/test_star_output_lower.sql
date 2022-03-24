{% set actual_output = dbt_utils.star(from=ref('data_star_uppercase_columns'), except=['field_1', 'field_2'], prefix='test_', output_lower=True ) %}

{% set expected_output %}
"field_3" as "test_field_3"
{% endset %}

{{ assert_equal_values (actual_output | trim, expected_output | trim) }}