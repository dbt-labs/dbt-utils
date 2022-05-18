with data as (

    select * from {{ ref('data_create_array') }}

),

create_array as (
    select
        {{ dbt_utils.create_array(['num_input_1', 'num_input_2', 'num_input_3']) }} as array_actual,
        cast({{ dbt_utils.create_array(['num_input_1', 'num_input_2', 'num_input_3']) }} as {{ dbt_utils.type_string() }}) as actual,
        result_as_string as expected

    from data

)

-- when casting as array to string, postgres uses {} (ex: {1,2,3}) while other dbs use [] (ex: [1,2,3])
-- we need to cast the arrays to strings in order to compare them to the output in our seed file  
select
    array_actual,
    {{ dbt_utils.replace(dbt_utils.replace('actual',"'}'","']'"),"'{'","'['") }} as actual,
    expected
from create_array