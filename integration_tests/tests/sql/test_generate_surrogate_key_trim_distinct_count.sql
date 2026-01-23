-- Test that the trim parameter correctly affects the number of distinct surrogate keys
-- key_with_trim should have 1 distinct value (all whitespace trimmed = identical inputs)
-- key_no_trim should have 4 distinct values (whitespace preserved = different inputs)

with counts as (
    select
        count(distinct key_with_trim) as distinct_count_with_trim,
        count(distinct key_no_trim) as distinct_count_no_trim
    from {{ ref('test_generate_surrogate_key_trim') }}
)

select *
from counts
where distinct_count_with_trim != 1
   or distinct_count_no_trim != 4
