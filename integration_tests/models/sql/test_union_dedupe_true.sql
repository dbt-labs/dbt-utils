select
    id,
    favorite_color
from 
(
{{ dbt_utils.union_relations([
        ref('data_union_table_dedupe'),
        ref('data_union_table_dedupe')],
        dedupe=True
) }} 
) as unioned
