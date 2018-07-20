
select
    {{dbt_utils.coalesce_0("field_1")}},
    {{dbt_utils.coalesce_0('"tbl"."field_2"')}},
    {{dbt_utils.coalesce_0("field_3", "field_3_alias")}}

from {{ref('data_coalesce_0')}} as tbl
