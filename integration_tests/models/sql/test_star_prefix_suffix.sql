{% set prefix_with = 'prefix_' %}
{% set suffix_with = '_suffix' %}

with data as (

    select
        {{ dbt_utils.star(from=ref('data_star'), prefix=prefix_with, suffix=suffix_with) }}

    from {{ ref('data_star') }}

)

select * from data