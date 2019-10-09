{% macro test_mutually_exclusive_ranges(model, lower_bound_column, upper_bound_column, partition_by=None, collectively_exhaustive=False) %}

{% set partition_clause="partition by " ~ partition_by if partition_by else '' %}
{% set collectively_exhaustive_operator='=' if collectively_exhaustive else '<=' %}
with calc as (

    select
        {% if partition_by %}
        {{ partition_by }},
        {% endif %}
        {{ lower_bound_column }} as lower_bound,
        {{ upper_bound_column }} as upper_bound,

        lag({{ upper_bound_column }}) over (
            {{ partition_clause }}
            order by {{ lower_bound_column }}
        ) as previous_upper_bound,

        lead({{ lower_bound_column }}) over (
            {{ partition_clause }}
            order by {{ lower_bound_column }}
        ) as next_lower_bound

    from {{ model }}

),

validation_errors as (
    -- we want to return records where our assumptions are NOT true, so we'll use
    -- the `not` function here so we can write our assumptions nore cleanly
    select * from calc
    where (
        -- lower_bound should always be before upper_bound
        not(lower_bound < upper_bound)

        -- upper_bound should always be before/the same as the next lower_bound
        -- (coalesce it to handle null cases for the last record)
        or not(
            coalesce(
                upper_bound {{ collectively_exhaustive_operator }} next_lower_bound,
                true
            )
        )

        -- lower_bound should always be the after/the same as the previous upper_bound
        -- (coalesce it to handle null cases for the first record
        or not(
            coalesce(
                previous_upper_bound {{ collectively_exhaustive_operator }} lower_bound,
                true
            )
        )
    )
)

select count(*) from validation_errors
{% endmacro %}
