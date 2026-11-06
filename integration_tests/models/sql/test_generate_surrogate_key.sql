
with data as (

    select * from {{ ref('data_generate_surrogate_key') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['column_1']) }} as actual_column_1_only,
    expected_column_1_only,
    {{ dbt_utils.generate_surrogate_key(['column_1', 'column_2', 'column_3']) }} as actual_all_columns_list,
    expected_all_columns,
    {{ dbt_utils.generate_surrogate_key(['column_1', "'monthly-sales'"]) }} as actual_with_string_literal,
    expected_with_string_literal,
    {{ dbt_utils.generate_surrogate_key(['column_1', '42']) }} as actual_with_numeric_literal,
    expected_with_numeric_literal

from data
