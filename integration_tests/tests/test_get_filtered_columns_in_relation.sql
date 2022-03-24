{% set actual_output = dbt_utils.get_filtered_columns_in_relation(from= ref('data_star_uppercase_columns'), except=['field_1'], output_lower=True) %}

{% set expected_output = ['field_2', 'field_3'] %}

{{ assert_equal_values (actual_output | trim, expected_output | trim) }}
