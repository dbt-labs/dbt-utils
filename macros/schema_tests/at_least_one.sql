{% macro test_at_least_one(model) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}

select count(*)
from (
    select
        {# In TSQL, subquery aggregate columns need aliases #}
        {# thus: a filler col name, 'filler_column' #}
      count({{ column_name }}) as filler_column

    from {{ model }}

    having count({{ column_name }}) = 0

) validation_errors

{% endmacro %}
