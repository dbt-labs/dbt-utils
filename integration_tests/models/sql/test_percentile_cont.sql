with data as (

    select * from {{ ref('data_percentile') }}

),

calculated as (

    select
        {{ dbt_utils.percentile_cont('val', 0.5) }} as actual,
        30 as expected

    from data

)

select distinct actual, expected from calculated
