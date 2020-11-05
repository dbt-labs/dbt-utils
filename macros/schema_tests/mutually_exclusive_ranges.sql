{% macro test_mutually_exclusive_ranges(model, lower_bound_column, upper_bound_column, partition_by=None, gaps='allowed') %}

{% if gaps == 'not_allowed' %}
    {% set allow_gaps_operator='=' %}
    {% set allow_gaps_operator_in_words='equal_to' %}
{% elif gaps == 'allowed' %}
    {% set allow_gaps_operator='<=' %}
    {% set allow_gaps_operator_in_words='less_than_or_equal_to' %}
{% elif gaps == 'required' %}
    {% set allow_gaps_operator='<' %}
    {% set allow_gaps_operator_in_words='less_than' %}
{% elif gaps == 'consecutive_dates' %}
    {% set allow_gaps_operator='=' %}
    {% set allow_gaps_operator_in_words='equal_to' %}
{% else %}
    {{ exceptions.raise_compiler_error(
        "`gaps` argument for mutually_exclusive_ranges test must be one of ['not_allowed', 'allowed', 'required', 'consecutive_dates'] Got: '" ~ gaps ~"'.'"
    ) }}
{% endif %}

{% if gaps == 'consecutive_dates' %}
     {% set next_bound_for_comparison='day_before_next_lower_bound' %}
{% else %}
     {% set next_bound_for_comparison='next_lower_bound' %}
{% endif %}

{% set partition_clause="partition by " ~ partition_by if partition_by else '' %}

with window_functions as (

    select
        {% if partition_by %}
        {{ partition_by }},
        {% endif %}
        {{ lower_bound_column }} as lower_bound,
        {{ upper_bound_column }} as upper_bound,

        lead(
            {% if gaps == 'consecutive_dates' %}
            {{ dbt_utils.dateadd('day', -1, lower_bound_column) }}
            {% else %}
            {{ lower_bound_column }}
            {% endif %}
        ) over (
            {{ partition_clause }}
            order by {{ lower_bound_column }}
        ) as {{ next_bound_for_comparison }},

        row_number() over (
            {{ partition_clause }}
            order by {{ lower_bound_column }} desc
        ) = 1 as is_last_record

    from {{ model }}

),

calc as (
    -- We want to return records where one of our assumptions fails, so we'll use
    -- the `not` function with `and` statements so we can write our assumptions more cleanly
    select
        *,

        -- For each record: lower_bound should be < upper_bound.
        -- Coalesce it to return an error on the null case (implicit assumption
        -- these columns are not_null)
        coalesce(
            lower_bound < upper_bound,
            false
        ) as lower_bound_less_than_upper_bound,

        -- For each record: upper_bound {{ allow_gaps_operator }} {{ next_bound_for_comparison }}.
        -- Coalesce it to handle null cases for the last record.
        coalesce(
            upper_bound {{ allow_gaps_operator }} {{ next_bound_for_comparison }},
            is_last_record,
            false
        ) as upper_bound_{{ allow_gaps_operator_in_words }}_{{ next_bound_for_comparison }}

    from window_functions
),

validation_errors as (

    select
        *
    from calc

    where not(
        -- THE FOLLOWING SHOULD BE TRUE --
        lower_bound_less_than_upper_bound
        and upper_bound_{{ allow_gaps_operator_in_words }}_{{ next_bound_for_comparison }}
    )
)

select count(*) from validation_errors
{% endmacro %}
