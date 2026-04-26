
select
    id,
    name,
    favorite_color,
    favorite_number

from {{ ref('test_union_base') }}
