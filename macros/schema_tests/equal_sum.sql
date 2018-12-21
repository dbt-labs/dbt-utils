{% macro test_equal_sum(model) %}

{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set compare_model = kwargs.get('compare_model', kwargs.get('arg')) %}
{% set compare_column_name = kwargs.get('compare_column', kwargs.get('arg')) %}

{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

with a as (

    select sum({{ column_name }}) as sum_a from {{ model }}

),
b as (

    select sum({{ compare_column_name }}) as sum_b from {{ compare_model }}

),
final as (

    select abs(
            (select sum_a from a) -
            (select sum_b from b)
            )
        as diff_sum

)

select diff_sum from final

{% endmacro %}