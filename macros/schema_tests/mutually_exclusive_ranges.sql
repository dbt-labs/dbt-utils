{% macro test_mutually_exclusive_ranges(model, lower_bound_column, upper_bound_column, partition_by=None, allow_gaps=True) %}

{% set partition_clause="partition by " ~ partition_by if partition_by else '' %}
{% set allow_gaps_operator='<=' if allow_gaps else '=' %}
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
        ) as next_lower_bound,

        row_number() over (
            {{ partition_clause }}
            order by {{ lower_bound_column }}
        ) = 1 as is_first_record,

        row_number() over (
            {{ partition_clause }}
            order by {{ lower_bound_column }} desc
        ) = 1 as is_last_record

    from {{ model }}

),

validation_errors as (
    -- We want to return records where one of our assumptions fails, so we'll use
    -- the `not` function with `and` statements so we can write our assumptions nore cleanly
    select * from calc
    where not(
        -- ALL OF THE FOLLOWING SHOULD BE TRUE --

        -- For each record: lower_bound should be < upper_bound.
        -- Coalesce it to return an error on the null case (implicit assumption
        -- these columns are not_null)
        coalesce(
            lower_bound < upper_bound,
            false
        )

        -- For each record: upper_bound <= the next lower_bound.
        -- Coalesce it to handle null cases for the last record.
        and coalesce(
            upper_bound {{ allow_gaps_operator }} next_lower_bound,
            is_last_record,
            false
        )

        -- For each record: lower_bound >= previous_upper_bound.
        -- Switch the order of this statement to use the same operator.
        -- Coalesce it to handle null cases for the first record
        and coalesce(
            previous_upper_bound {{ allow_gaps_operator }} lower_bound,
            is_first_record,
            false
        )
    )
)

select count(*) from validation_errors
{% endmacro %}
