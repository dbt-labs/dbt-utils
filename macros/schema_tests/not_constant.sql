
{% macro test_not_constant(model, arg) %}

select count(*)

from (

    select
          count(distinct {{ arg }})

    from {{ model }}

    having count(distinct {{ arg }}) = 1

    ) validation_errors


{% endmacro %}
