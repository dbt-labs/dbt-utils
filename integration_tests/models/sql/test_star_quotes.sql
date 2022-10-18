with data as (

    select
        {{ dbt_utils.star(from=ref('data_star_quotes'), quote_identifiers=False) }}

    from {{ ref('data_star_quotes') }}

)

select * from data