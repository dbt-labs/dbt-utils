
    {{ dbt_utils.unpivot(
        relation=ref('data_unpivot_quote'),
        cast_to=type_string(),
        exclude=['customer_id', 'created_at'],
        remove=['name'],
        field_name='prop',
        value_name='val',
        quote_identifiers=True,
    ) }}
