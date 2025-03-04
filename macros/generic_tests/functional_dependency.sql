{% test functional_dependency(model, determinants, dependent, where_clause=None) %}
  {{ return(adapter.dispatch('test_functional_dependency', 'dbt_utils')(model, determinants, dependent, where_clause)) }}
{% endtest %}

{% macro default__test_functional_dependency(model, determinants, dependent, where_clause=None) %}

with filtered as (
    select *
    from {{ model }}
    {% if where_clause %}
    where {{ where_clause }}
    {% endif %}
),

violations as (
    select
        {% for col in determinants %}
        {{ col }}{% if not loop.last %}, {% endif %}
        {% endfor %},
        count(distinct {{ dependent }}) as distinct_dependent_count
    from filtered
    group by
        {% for col in determinants %}
        {{ col }}{% if not loop.last %}, {% endif %}
        {% endfor %}
    having count(distinct {{ dependent }}) > 1
)

select *
from violations

{% endmacro %}
