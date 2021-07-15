{{
	config(
		materialized = 'view',
		enabled=(target.type == 'redshift')
	)
}}

select * from {{ ref('expected_pageviews__sessionized') }}
