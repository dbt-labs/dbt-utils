{% test fewer_rows_than(model, compare_model, group_by_columns = []) %}
  {{ return(adapter.dispatch('test_fewer_rows_than', 'dbt_utils')(model, compare_model, group_by_columns)) }}
{% endtest %}

{% macro default__test_fewer_rows_than(model, compare_model, group_by_columns) %}

{{ config(fail_calc = 'sum(coalesce(row_count_delta, 0))') }}

{% if group_by_columns|length() > 0 %}
  {% set select_gb_cols = group_by_columns|join(' ,') + ', ' %}
  {% set join_gb_cols %}
    {% for c in group_by_columns %}
      and a.{{c}} = b.{{c}}
    {% endfor %}
  {% endset %}
  {% set groupby_gb_cols = 'group by ' + group_by_columns|join(',') %}
{% endif %}


with a as (

    select 
      {{select_gb_cols}}
      count(*) as count_our_model 
    from {{ model }}
    {{ groupby_gb_cols }}

),
b as (

    select 
      {{select_gb_cols}}
      count(*) as count_comparison_model 
    from {{ compare_model }}
    {{ groupby_gb_cols }}

),
counts as (

    select

        {% for c in group_by_columns -%}
          a.{{c}} as {{c}}_a,
          b.{{c}} as {{c}}_b,
        {% endfor %}

        count_our_model,
        count_comparison_model
    from a
    full outer join b on 
    1 = 1
    {{ join_gb_cols }}

),
final as (

    select *,
        case
            -- fail the test if we have more rows than the reference model and return the row count delta
            when count_our_model > count_comparison_model then (count_our_model - count_comparison_model)
            -- fail the test if they are the same number
            when count_our_model = count_comparison_model then 1
            -- pass the test if the delta is positive (i.e. return the number 0)
            else 0
    end as row_count_delta
    from counts

)

select * from final

{% endmacro %}
