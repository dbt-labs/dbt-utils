with data as (

    select
        {{ dbt_utils.star(from=ref('data_star'), except=['field_1', 'field_2', 'field_3']) }}
        -- if star() returns `*` or a list of columns, this query will fail because there's no comma between the columns
        1 as canary_column
    from {{ ref('data_star') }}

)

select * from data
