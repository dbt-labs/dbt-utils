{{
	config(
		materialized = 'view',
		enabled=(target.type == 'redshift')
	)
}}

select id
from {{ ref('data_insert_by_period') }}
where id in (
    select id
    from {{ ref('data_insert_by_period') }}
    where new_session = 1
)
