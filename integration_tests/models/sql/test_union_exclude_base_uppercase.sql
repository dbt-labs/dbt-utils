
{{ dbt_utils.union_relations(
    relations=[
        ref('data_union_table_1'),
        ref('data_union_table_2'),
    ],
    exclude=['NAME']
) }}
