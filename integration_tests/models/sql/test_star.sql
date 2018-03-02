
with data as (

    select
        {{ dbt_utils.star(from=ref('data_star'), except=['field_3']) }}

    from {{ ref('data_star') }}

)

select * from data
