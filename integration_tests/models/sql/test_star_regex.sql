{% set regex = '.+[^3]$' %}


with data as (

    select
        {{ dbt_utils.star(from=ref('data_star'), regex=regex) }}

    from {{ ref('data_star') }}

)

select * from data
