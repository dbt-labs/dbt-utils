select
    {{ dbt_utils.star(ref("test_union_exclude_base_uppercase"), except=["_DBT_SOURCE_RELATION"]) }}

from {{ ref("test_union_exclude_base_uppercase") }}
