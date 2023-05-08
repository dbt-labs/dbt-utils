select
    -- snowflake requires quoted column names for this test
    {{ adapter.quote("customer_id") }},
    {{ adapter.quote("created_at") }},
    {{ adapter.quote("prop") }},
    {{ adapter.quote("val") }}

from (
    {{ dbt_utils.unpivot(
        relation=ref('data_unpivot_quote'),
        cast_to=type_string(),
        exclude=['customer_id', 'created_at'],
        remove=['name'],
        field_name='prop',
        value_name='val',
        quote_identifiers=True,
    ) }}
) as sbq
