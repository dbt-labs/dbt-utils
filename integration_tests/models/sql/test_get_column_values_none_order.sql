{% set column_values = dbt_utils.get_column_values(ref('data_get_column_values'), 'field', order_by=none) %}

-- Create a relation using the values
{% for val in column_values -%}
select {{ string_literal(val) }} as field {% if not loop.last %}union all{% endif %} 
{% endfor %}