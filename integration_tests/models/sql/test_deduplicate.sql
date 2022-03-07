with deduped as (

    {{ dbt_utils.deduplicate(ref('data_deduplicate'), group_by='user_id', order_by='version desc') | indent }}

)

select * from deduped
