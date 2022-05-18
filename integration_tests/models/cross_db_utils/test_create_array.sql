with data as (

    select * from {{ ref('data_create_array') }}

)

select
    {{ dbt_utils.create_array(['num_input_1', 'num_input_2', 'num_input_3']) }} as array_actual,
    cast({{ dbt_utils.create_array(['num_input_1', 'num_input_2', 'num_input_3']) }} as {{ dbt_utils.type_string() }}) as actual,
    result_as_string as expected

from data