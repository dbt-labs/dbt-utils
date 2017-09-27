/*this macro tests that a model produces zero results */

{%- endmacro %}

{% macro test_empty(model,arg) -%}
    select
{% if arg == True %}
    case when results=0 then 0 else results end
{% else %}
    case when results>0 then 0 else results end
{% endif %}
    from
        (select count(*) as results
        from {{model}})
{%- endmacro%}
