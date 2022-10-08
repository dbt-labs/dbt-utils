select
    customer_id,
    created_at,
    prop,
    val

from (
    {{ dbt_utils.unpivot(
        relation=ref('data_unpivot_quote_identifiers'),
        cast_to=type_string(),
        exclude=['customer_id', 'created_at'],
        field_name='prop',
        value_name='val',
        quote_identifiers=true
    ) }}
) as sbq
order by
    customer_id asc,
    created_at asc,
    prop asc
