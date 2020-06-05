with source as (
    select * from {{ ref('data_test_accepted_values_from_source') }}
), not_renamed as(
    select id,
           lookup
    from source
)
select * from not_renamed
