-- Regression tests for https://github.com/dbt-labs/dbt-utils/issues/980
--
-- `get_url_parameter` must only match a parameter when the search token
-- appears as a complete parameter name — not when the token happens to be
-- a suffix of a different parameter name. The cases below all used to
-- return the matched substring's value rather than NULL.

with cases as (

    select
        'http://example.com/?msg=hello'                               as url,
        'g'                                                           as param,
        cast(null as {{ dbt.type_string() }})                         as expected

    union all

    select
        'http://example.com/?sku=EXAMPLE_SKU&u=https%3A%2F%2Fx.com',
        'ku',
        cast(null as {{ dbt.type_string() }})

    union all

    -- Legitimate short-name parameter matches must still resolve correctly.
    select
        'http://example.com/?m=first_value&s=second_value',
        'm',
        'first_value'

    union all

    select
        'http://example.com/?m=first_value&s=second_value',
        's',
        'second_value'

    union all

    -- Existing behaviour must be preserved.
    select
        'http://example.com/?utm_medium=organic&utm_source=github',
        'utm_source',
        'github'

    union all

    select
        'http://example.com/?utm_medium=organic&utm_source=github',
        'utm_medium',
        'organic'

),

comparisons as (

    select
        {{ dbt_utils.get_url_parameter('url', 'g') }}           as actual,
        case when param = 'g' then expected end                 as expected,
        param
    from cases
    where param = 'g'

    union all

    select
        {{ dbt_utils.get_url_parameter('url', 'ku') }}          as actual,
        case when param = 'ku' then expected end                as expected,
        param
    from cases
    where param = 'ku'

    union all

    select
        {{ dbt_utils.get_url_parameter('url', 'm') }}           as actual,
        case when param = 'm' then expected end                 as expected,
        param
    from cases
    where param = 'm'

    union all

    select
        {{ dbt_utils.get_url_parameter('url', 's') }}           as actual,
        case when param = 's' then expected end                 as expected,
        param
    from cases
    where param = 's'

    union all

    select
        {{ dbt_utils.get_url_parameter('url', 'utm_source') }}  as actual,
        case when param = 'utm_source' then expected end        as expected,
        param
    from cases
    where param = 'utm_source'

    union all

    select
        {{ dbt_utils.get_url_parameter('url', 'utm_medium') }}  as actual,
        case when param = 'utm_medium' then expected end        as expected,
        param
    from cases
    where param = 'utm_medium'

)

-- A row is a failure if actual and expected disagree, treating NULLs as equal.
select *
from comparisons
where
    (actual is null) <> (expected is null)
    or coalesce(actual, '') <> coalesce(expected, '')
