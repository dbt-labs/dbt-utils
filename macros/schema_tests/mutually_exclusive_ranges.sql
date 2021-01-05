{% macro test_mutually_exclusive_ranges(model, lower_bound_column, upper_bound_column, partition_by=None, zero_length_range_allowed=False, gaps='allowed', gap_interval_constraints=[]) %}

{% if gaps == 'not_allowed' %}
    {% set allow_gaps_operator='=' %}
    {% set allow_gaps_operator_in_words='equal_to' %}
{% elif gaps == 'allowed' %}
    {% set allow_gaps_operator='<=' %}
    {% set allow_gaps_operator_in_words='less_than_or_equal_to' %}
{% elif gaps == 'required' %}
    {% set allow_gaps_operator='<' %}
    {% set allow_gaps_operator_in_words='less_than' %}
{% elif gaps == 'interval_constrained' %}
    {% set allow_gaps_operator='=' %}
    {% set allow_gaps_operator_in_words='equal_to' %}
{% else %}
    {{ exceptions.raise_compiler_error(
        "`gaps` argument for mutually_exclusive_ranges test must be one of ['not_allowed', 'allowed', 'required', 'interval_constrained'] Got: '" ~ gaps ~"'.'"
    ) }}
{% endif %}

{% if gaps == 'interval_constrained' %}
    {% if not gap_interval_constraints %}
        {{ exceptions.raise_compiler_error(
            "When `gaps: interval_constrained` the `gap_interval_constraints` argument must also be supplied."
        ) }}
    {% endif %}
    {% if not gap_interval_constraints.fixed_interval %}
        {{ exceptions.raise_compiler_error(
            "`fixed_interval` must be specified in `gap_interval_constraints`."
        ) }}
    {% endif %}
{% else %}
    {% if gap_interval_constraints %}
        {{ exceptions.raise_compiler_error(
            "`gap_interval_constraints` can only be used with `gaps: interval_constrained`."
        ) }}
    {% endif %}
{% endif %}

{% if not zero_length_range_allowed %}
    {% set allow_zero_length_operator = '<' %}
    {% set allow_zero_length_operator_in_words = 'less_than' %}
{% elif zero_length_range_allowed %}
    {% set allow_zero_length_operator = '<=' %}
    {% set allow_zero_length_operator_in_words = 'less_than_or_equal_to' %}
{% else %}
    {{ exceptions.raise_compiler_error(
        "`zero_length_range_allowed` argument for mutually_exclusive_ranges test must be one of [true, false] Got: '" ~ zero_length ~"'.'"
    ) }}
{% endif %}

{% set partition_clause="partition by " ~ partition_by if partition_by else '' %}

with window_functions as (

    select
        {% if partition_by %}
            {# Include columns that will be partitioned by if there are any #}
            {{ partition_by }},
        {% endif %}
        {{ lower_bound_column }} as lower_bound,
        {{ upper_bound_column }} as upper_bound,

        lead(
            {% if gaps == 'interval_constrained' %}
                {% if gap_interval_constraints.datepart %}
                    {{ dbt_utils.dateadd(
                        gap_interval_constraints.datepart,
                        -gap_interval_constraints.fixed_interval,
                        lower_bound_column
                    ) }}
                {% else %}
                    {{ lower_bound_column }} - {{ gap_interval_constraints.fixed_interval }}
                {% endif %}
            {% else %}
                {{ lower_bound_column }}
            {% endif %}
        ) over (
            {{ partition_clause }}
            order by {{ lower_bound_column }}
        ) as next_comparison_lower_bound,

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
            lower_bound {{ allow_zero_length_operator }} upper_bound,
            false
        ) as lower_bound_{{ allow_zero_length_operator_in_words }}_upper_bound,

        -- For each record: upper_bound {{ allow_gaps_operator }} next_comparison_lower_bound.
        -- Coalesce it to handle null cases for the last record.
        coalesce(
            upper_bound {{ allow_gaps_operator }} next_comparison_lower_bound,
            is_last_record,
            false
        ) as upper_bound_{{ allow_gaps_operator_in_words }}_next_comparison_lower_bound

    from window_functions
),

validation_errors as (

    select
        *
    from calc

    where not(
        -- THE FOLLOWING SHOULD BE TRUE --
        lower_bound_{{ allow_zero_length_operator_in_words }}_upper_bound
        and upper_bound_{{ allow_gaps_operator_in_words }}_next_comparison_lower_bound
    )
)

select count(*) from validation_errors
{% endmacro %}
