select 
    "id"
    ,"name"
    ,"favorite_number"
    ,"favorite_color"
    ,"high_score"
from {{ ref('test_union_fill_value_base_int') }}
