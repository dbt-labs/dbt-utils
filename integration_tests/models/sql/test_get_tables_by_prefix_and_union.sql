{{config( materialized = 'table')}}

{% set tables = dbt_utils.get_tables_by_prefix(target.schema, 'data_events_') %}
{{ dbt_utils.union_tables(tables) }}
