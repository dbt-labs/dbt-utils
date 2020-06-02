{% macro test_json_paths_not_null (model) %}
    {% set column_name = kwargs.get('column_name') %}
    {% set paths = kwargs.get('paths', []) %}

    with validation_errors as (
        select
            {% for path in paths %}
                {{column_name}}:{{ path }} {%if not loop.last%}, {% endif %}
            {% endfor %}
        from
            {{ model }}
        where
             {% for path in paths %}
                {{column_name}}:{{ path }} is null {%if not loop.last%} or {% endif %}
            {% endfor %}
    )
    select
        count(*)
    from
         validation_errors

{% endmacro %}
