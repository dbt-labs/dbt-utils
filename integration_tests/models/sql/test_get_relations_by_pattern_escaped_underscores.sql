{{ config(materialized = 'table', enabled = target.type == 'snowflake') }}

-- depends_on: {{ ref('data_orders_x') }}, {{ ref('data_orders__x') }}, {{ ref('data_orders___x') }}

{% set relations = dbt_utils.get_relations_by_pattern(target.schema, 'data_orders\_\_\_%') %}

with unioned as (

    {{ dbt_utils.union_relations(relations) }}

)

select

    label

from unioned
