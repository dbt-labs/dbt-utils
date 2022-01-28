{% set regex = ".+[^3]$" | string %}


with data as (

    select {{ dbt_utils.star(ref('data_star'), regex=regex) }}

    from {{ ref('data_star') }}

)

select * from data

