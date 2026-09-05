{#
    Validates that test_expression_is_true emits a column alias for its
    placeholder column so that the rendered SQL is valid inside a subquery
    on strict-alias dialects (e.g. T-SQL / Microsoft Fabric Data Warehouse,
    some Spark configurations). Previously the macro emitted `select 1
    from ...`, which compiles standalone but fails with errors like
    "Missing column specification" (Snowflake, historical) or "no column
    name was specified for column 1 of 'sub'" (T-SQL) once any caller wraps
    the result in another SELECT. See dbt-labs/dbt-utils#822.

    This test compiles the macro for a model with column_name unset and
    wraps the rendered SQL in an outer SELECT. If the inner SELECT did not
    alias its placeholder column, the wrapping outer SELECT would fail to
    compile on strict-alias dialects.
#}

-- depends_on: {{ ref('data_test_expression_is_true') }}

{% set inner_sql = dbt_utils.test_expression_is_true(
    model=ref('data_test_expression_is_true'),
    expression='col_a + col_b = 1',
    column_name=none
) %}

with wrapped as (
    select * from (
        {{ inner_sql }}
    ) as sub
)

select *
from wrapped
where 1 = 0
