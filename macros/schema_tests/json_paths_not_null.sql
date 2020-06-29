{% macro test_json_paths_not_null(model) %}
    {{ adapter_macro('dbt_utils.test_json_paths_not_null', model, **kwargs) }}
{% endmacro %}

{% macro default__test_json_paths_not_null(model) %}
    {{ exceptions.raise_compiler_error("Schema test json_paths_not_null not implemented for this adapter") }}
{% endmacro %}

{% macro snowflake__test_json_paths_not_null (model) %}
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
