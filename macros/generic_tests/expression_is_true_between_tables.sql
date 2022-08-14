{% test expression_is_true_between_tables(model, model_alias, join_condition, expression, condition='1=1') %}
{# T-SQL has no boolean data type so we use 1=1 which returns TRUE #}
{# ref https://stackoverflow.com/a/7170753/3842610 #}
  {{ return(adapter.dispatch('test_expression_is_true_between_tables', 'dbt_utils')(model, model_alias, join_condition, expression, condition)) }}
{% endtest %}

{% macro default__test_expression_is_true_between_tables(model, model_alias, join_condition, expression, condition) %}

with meet_condition_not_expression as (
    select * from {{ model }} {{ model_alias }}
    {{ join_condition }}
    where {{ condition }} and not({{ expression }})
)

select
    *
from meet_condition_not_expression

{% endmacro %}
