{% test equal_rowcount(model, compare_model, group_by_columns = []) %}
  {{ return(adapter.dispatch('test_equal_rowcount', 'dbt_utils')(model, compare_model, group_by_columns)) }}
{% endtest %}

{% macro default__test_equal_rowcount(model, compare_model, group_by_columns) %}

{#-- Needs to be set at parse time, before we return '' below --#}
{{ config(fail_calc = 'sum(coalesce(diff_count, 0))') }}

{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

{% if group_by_columns|length() > 0 %}
  {% set select_gb_cols = group_by_columns|join(', ') + ', ' %}
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
      count(*) as count_a 
    from {{ model }}
    {{groupby_gb_cols}}


),
b as (

    select 
      {{select_gb_cols}}
      count(*) as count_b 
    from {{ compare_model }}
    {{groupby_gb_cols}}

),
final as (

    select
    
        {% for c in group_by_columns -%}
          a.{{c}} as {{c}}_a,
          b.{{c}} as {{c}}_b,
        {% endfor %}

        count_a,
        count_b,
        abs(count_a - count_b) as diff_count

    from a
    full outer join b
    on
    1 = 1
    {{join_gb_cols}}


)

select * from final

{% endmacro %}
