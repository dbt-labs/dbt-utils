with data as (

    select {{ dbt_utils.star(ref('data_star'), regex='field_(1|2)') }}

    from {{ ref('data_star') }}

)

select * from data

