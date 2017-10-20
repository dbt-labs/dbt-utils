{% macro coalesce_to_zero(field) -%}

    coalesce( {{ field }} ,0) {{field}}

{%- endmacro %}


{% macro normalize_resource(entity_name, resource_number) %}

    select
        {{entity_name}}_id,
        resource_{{resource_number}} as resource,
        resource_{{resource_number}}_credit as credit
    from {{entity_name}}s
    where resource_{{resource_number}} is not null

{% endmacro %}


{% macro dedup(from,except,dedup_choice,dedup_choice_column,unique_key) %}
{#dedup_choice options
    - random
    - max
    - min
#}

{% set columns = dbt_utils.star(from,except) %}

with cte as (
    select {{columns}},

    {% if dedup_choice=='random' %}

        row_number() over (partition by {{unique_key}} order by random()) as dup

    {% elif dedup_choice=='max'%}

        row_number() over (partition by {{unique_key}}
            order by {{dedup_choice_column}} desc nulls last) as dup

    {% elif dedup_choice=='min'%}

        row_number() over (partition by {{unique_key}}
            order by {{dedup_choice_column}} asc nulls last) as dup

    {% else %}

        {{exceptions.compiler_error('Invalid Dedup Choice')}}

    {% endif %}
    from {{from}}
)

select {{columns}}
from cte
where dup=1

{%- endmacro %}
