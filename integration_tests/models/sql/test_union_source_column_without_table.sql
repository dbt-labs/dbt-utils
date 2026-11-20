{%- set table_1 = ref('data_union_table_1') -%}

with unioned as (

    {{ dbt_utils.union_relations(
        relations=[table_1, ref('data_union_table_2')],
        include_table_in_source_column=false
    ) }}

)

select
    _dbt_source_relation as actual,
    cast({{ dbt.string_literal(table_1.database ~ '.' ~ table_1.schema) }} as {{ dbt.type_string() }}) as expected
from unioned
