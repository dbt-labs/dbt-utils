{% set pattern = '%_item' %}
{% set column_names = dbt_utils.get_columns_by_pattern(from=ref('data_columns_by_pattern'), pattern=pattern) %}

with data as (

    select

        {% for column_name in column_names %}
            max({{ column_name }}) as {{ column_name }} {% if not loop.last %},{% endif %}
        {% endfor %}

    from {{ ref('data_columns_by_pattern') }}

)

select * from data
