{% macro test_atleast_one(model, arg) %}

select count(*)

from

  (
    select *

    from (
       select
        count({{ arg }}) count_of_rows

        from {{ model }}
    ) rows_with_values

    where count_of_rows = 0 ) validation_errors

{% endmacro %}