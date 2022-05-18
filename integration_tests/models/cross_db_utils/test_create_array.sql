with data as (

    select * from {{ ref('data_create_array') }}

)

select
    {{ dbt_utils.create_array(['num_input', 'string_input', 'boolean_input', 'null_input']) }} as array_actual,
    cast({{ dbt_utils.create_array(['num_input', 'string_input', 'boolean_input', 'null_input']) }} as string) as actual,
    result_as_string as expected

from data