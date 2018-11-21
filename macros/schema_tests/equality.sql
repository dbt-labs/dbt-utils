{% macro test_equality(model) %}

{% set compare_model = kwargs.get('compare_model', kwargs.get('compare_model')) %}


{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

-- setup

{% set schema = model.schema %}
{% set model_a_name = model.name %}

{% set dest_columns = adapter.get_columns_in_table(schema, model_a_name) %}
{% set dest_cols_csv = dest_columns | map(attribute='quoted') | join(', ') %}



-- core SQL

with a as (

    select * from {{ model }}

),

b as (

    select * from {{ compare_model }}

),

a_minus_b as (

    select {{dest_cols_csv}} from a
    except
    select {{dest_cols_csv}} from b

),

b_minus_a as (

    select {{dest_cols_csv}} from b
    except
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
