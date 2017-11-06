{% macro test_not_constant(model, arg) %}

select count(*)
from
  (
  select
        count(distinct not_constant_field) count_of_distinct_rows
    from (
          select
              {{ arg }} as not_constant_field

          from {{ model }}

          where {{ arg }} is not null

         ) not_null_rows
  ) discount_rows_count

  where count_of_distinct_rows = 1

{% endmacro %}
