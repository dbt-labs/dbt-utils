with data as (

    select 
        data_array_append.element,
        data_array_append.result_as_string,
        data_create_array.num_input_1,
        data_create_array.num_input_2,
        data_create_array.num_input_3
    from {{ ref('data_array_append') }} as data_array_append
    left join {{ ref('data_create_array') }} as data_create_array
    on data_array_append.array_as_string = data_create_array.result_as_string

),

create_array as (
    select

        {{ dbt_utils.create_array(['num_input_1', 'num_input_2', 'num_input_3']) }} as array,
        element,
        result_as_string as expected

    from data

)

select

    {{ dbt_utils.array_append('array', 'element') }} as array_actual,
    cast({{ dbt_utils.array_append('array', 'element') }} as {{ dbt_utils.type_string() }}) as actual,
    expected

from create_array