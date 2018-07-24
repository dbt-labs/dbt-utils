
{% set columns = dbt_utils.get_column_values(ref('data_get_column_values'), 'field') %}


select
    {% for column in columns -%}

        sum(case when field = '{{ column }}' then 1 else 0 end) as count_{{ column }}
        {%- if not loop.last %},{% endif -%}

    {%- endfor %}

from {{ ref('data_get_column_values') }}
