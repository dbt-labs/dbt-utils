select 
    "id"
    ,"name"
    ,"favorite_number"
    ,"favorite_color"
from {{ ref('test_union_fill_value_base_case') }}
