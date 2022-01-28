with data as (

    select {{ dbt_utils.star(ref('data_star'), regex='r.+[^3]$') }}

    from {{ ref('data_star') }}

)

select * from data

