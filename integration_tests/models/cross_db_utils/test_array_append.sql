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

appended_array as (

    select
        {{ dbt_utils.array_append(dbt_utils.create_array(['num_input_1', 'num_input_2', 'num_input_3']), 'element') }} as array_actual,
        cast({{ dbt_utils.array_append(dbt_utils.create_array(['num_input_1', 'num_input_2', 'num_input_3']), 'element') }} as {{ dbt_utils.type_string() }}) as actual,
        result_as_string as expected
    from data

)

-- when casting as array to string, postgres uses {} (ex: {1,2,3}) while other dbs use [] (ex: [1,2,3])
-- we need to cast the arrays to strings in order to compare them to the output in our seed file  
select
    array_actual,
    {{ dbt_utils.replace(dbt_utils.replace('actual',"'}'","']'"),"'{'","'['") }} as actual,
    expected
from appended_array