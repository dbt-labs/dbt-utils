{%- set default_ref = ref('data_get_single_column_row_value')|string -%}

with default_data as (

    select 
        {{ dbt_utils.get_query_results_as_single_value('select * from '+ default_ref,0,0) }} as date_value,
        {{ dbt_utils.get_query_results_as_single_value('select * from '+ default_ref,0,1) }} as float_value,
        {{ dbt_utils.get_query_results_as_single_value('select * from '+ default_ref,0,2) }} as integer_value,
        {{ dbt_utils.get_query_results_as_single_value('select * from '+ default_ref,0,3) }} as string_value
    from {{ ref('data_get_single_column_row_value') }}

)

select * 
from default_data