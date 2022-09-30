with

default_query as (
    select *
    from {{ ref('data_get_single_column_row_value') }}
),

default_data as (

    select {{ dbt_utils.get_query_results_as_single_value(default_query) }} as default_value
    from {{ ref('data_get_single_column_row_value') }}

)

select * from default_data