select
    {{ dbt_utils.star(ref("test_union_exclude_base_lowercase"), except=["_dbt_source_relation"]) }}

from {{ ref("test_union_exclude_base_lowercase") }}
