{% macro test_at_least_one(model, arg) %}

select count(*)
from (
    select

      count({{ arg }})

    from {{ model }}

    having count({{ arg }}) = 0

) validation_errors

{% endmacro %}
