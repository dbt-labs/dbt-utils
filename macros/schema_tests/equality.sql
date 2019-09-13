{% macro test_equality(model) %}

{% set compare_model = kwargs.get('compare_model', kwargs.get('arg')) %}


{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

-- setup
{%- do dbt_utils._is_relation(model, 'test_equality') -%}
{% set dest_columns = adapter.get_columns_in_relation(model) %}
{% set dest_cols_csv = dest_columns | map(attribute='quoted') | join(', ') %}

with a as (

    select * from {{ model }}

),

b as (

    select * from {{ compare_model }}

),

a_minus_b as (

    select {{dest_cols_csv}} from a
    {{ dbt_utils.except() }}
    select {{dest_cols_csv}} from b

),

b_minus_a as (

    select {{dest_cols_csv}} from b
    {{ dbt_utils.except() }}
    select {{dest_cols_csv}} from a

),

unioned as (

    select * from a_minus_b
    union all
    select * from b_minus_a

),

final as (

    select (select count(*) from unioned) +
        (select abs(
            (select count(*) from a_minus_b) -
            (select count(*) from b_minus_a)
            ))
        as count

)

select count from final

{% endmacro %}
