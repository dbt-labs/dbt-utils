{% macro test_accepted_values_from(model) %}
    {% set column_name = kwargs.get('column_name') %}
    {% set from_relationship = kwargs.get('relationship') %}
    {% set referenced_column = kwargs.get('field', column_name) %}
    {% set filter = kwargs.get('filter', 'true') %}
    with accepted_values as (
        select
            distinct( {{ referenced_column }}) as accepted
        from
            {{ from_relationship }}
        where
            {{ filter }}
    ), validation_failures as (
        select
            {{ column_name }}
        from
            {{ model }}
        where
            {{ column_name }} not in (select accepted from accepted_values)
    )
    select
           count(*)
    from
         validation_failures



{% endmacro %}
