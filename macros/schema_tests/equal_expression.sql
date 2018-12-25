{% macro get_columns(group_by) %}
{% set i = 1 %}
    {% if group_by %}
        {% for g in group_by %}
            {{ g }} as col_{{ i }}
            {%- if not loop.last %}, {% endif -%}
            {% set i = i + 1 %}
        {% endfor %}
    {% endif %}
{% endmacro %}

{% macro get_select(model, expression, group_by) %}
    select
        {{ get_columns(group_by) }},
        {{ expression }} as expression
    from 
        {{ model }}
    {{ dbt_utils.group_by(group_by|length) }}
{% endmacro %}

{% macro test_equal_expression(model, expression, 
                                compare_model=None, 
                                compare_expression=None, 
                                group_by=["'col'"], 
                                compare_group_by=None, 
                                tol=0.0) %}

    {% set compare_model = model if not compare_model else compare_model%} 
    {% set compare_expression = expression if not compare_expression else compare_expression%} 
    {% set compare_group_by = group_by if not compare_group_by else compare_group_by%} 

    {% set n_cols = group_by|length %}

    with a as (

        {{ get_select(model, expression, group_by) }}
    ),
    b as (

        {{ get_select(compare_model, compare_expression, compare_group_by) }}

    ),
    final as (

        select 
            {% for i in range(1, n_cols + 1) %}
            coalesce(a.col_{{ i }}, b.col_{{ i }}) as col_{{ i }},
            {% endfor %}
            abs(coalesce(a.expression, 0) - coalesce(b.expression, 0)) as exp_diff
        from
            a
            full outer join
            b on
            {% for i in range(1, n_cols + 1) %}
                a.col_{{ i }} = b.col_{{ i }} {% if not loop.last %} and {% endif %}
            {% endfor %}
    )

    select count(*) from final where exp_diff > {{ tol }}

{% endmacro %}