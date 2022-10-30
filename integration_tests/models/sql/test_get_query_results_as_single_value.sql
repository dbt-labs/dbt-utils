{%- set default_ref = ref('data_get_single_column_row_value') -%}

with default_data as (

    select 
        {{ dbt_utils.get_query_results_as_single_value('select date_value from '+ default_ref) }} as date_value,
        {{ dbt_utils.get_query_results_as_single_value('select float_value from '+ default_ref) }} as float_value,
        {{ dbt_utils.get_query_results_as_single_value('select int_value from '+ default_ref) }} as int_value,
        {{ dbt_utils.get_query_results_as_single_value('select string_value from '+ default_ref) }} as string_value
    from {{ ref('data_get_single_column_row_value') }}

)

select * 
from default_data