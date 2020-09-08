{% macro test_accepted_range(model, min_value = none, max_value = none, inclusive = true, where = "true") %}

{%- set column_name = kwargs.get('column_name', kwargs.get('field')) -%}

with meet_condition as(
  select {{ column_name }} 
  from {{ model }}
  where {{ where }}
),

validation_errors as (
  select *
  from meet_condition
  where 
    -- never true, defaults to an empty result set. Exists to ensure any combo of the `or` clauses below succeeds
    1 = 2 

  {%- if min_value is not none %}
    -- records with a value >= min_value are permitted. The `not` flips this to find records that don't meet the rule.
    or not {{ column_name }} > {{- "=" if inclusive }} {{ min_value }} 
  {%- endif %}

  {%- if max_value is not none %}
    -- records with a value <= max_value are permitted. The `not` flips this to find records that don't meet the rule.
    or not {{ column_name }} < {{- "=" if inclusive }} {{ max_value }}
  {%- endif %}
)

select count(*)
from validation_errors

{% endmacro %}
