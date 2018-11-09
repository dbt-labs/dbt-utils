
-- TODO: How do we make this work nicely on Snowflake too?

{% if target.type == 'snowflake' %}
    {% set column_values = ['RED COLOR', 'BLUE COLOR'] %}
    {% set cmp = 'ilike' %}
{% else %}
    {% set column_values = ['Red Color', 'Blue Color'] %}
    {% set cmp = '=' %}
{% endif %}

select
    size,
    {{ dbt_utils.pivot('color', column_values, cmp=cmp, slug=True) }}

from {{ ref('data_pivot_slug') }}
group by size
