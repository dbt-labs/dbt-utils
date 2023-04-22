{{ dbt_utils.union_relations([
        ref('data_union_table_1'),
        ref('data_union_table_3')],
        fill_values={'name': 'gandalf', 'favorite_color': 4, 'high_score': 99}
) }}
