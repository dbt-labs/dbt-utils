
    {{ dbt_utils.unpivot(
        relation=ref('data_unpivot_quote'),
        cast_to=type_string(),
        exclude=['Customer_Id', 'Created_At'],
        remove=['Name'],
        field_name='Prop',
        value_name='Val',
        quote_identifiers=True,
    ) }}
