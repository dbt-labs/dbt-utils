with data as (

    select * from {{ ref('data_create_array') }}

),

create_array as (
    select
        {{ dbt_utils.create_array(['num_input_1', 'num_input_2', 'num_input_3']) }} as array_actual,
        result_as_string as expected

    from data

)

-- we need to cast the arrays to strings in order to compare them to the output in our seed file  
select
    array_actual,
    {{ dbt_utils.cast_array_to_string('array_actual') }} as actual,
    expected
from create_array