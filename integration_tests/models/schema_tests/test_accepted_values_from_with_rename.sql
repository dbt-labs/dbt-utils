with source as (
    select * from {{ ref('data_test_accepted_values_from_source') }}
), renamed as(
    select id,
           lookup as destination_column
    from source
)
select * from renamed
