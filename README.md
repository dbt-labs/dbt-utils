This [dbt](https://github.com/fishtown-analytics/dbt) package contains macros that can be (re)used across dbt projects.

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/fishtown-analytics/dbt_utils/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

----

## Macros
### Cross-database
#### current_timestamp ([source](macros/cross_db_utils/current_timestamp.sql))
This macro returns the current timestamp.

Usage:
```
{{ dbt_utils.current_timestamp() }}
```

#### dateadd ([source](macros/cross_db_utils/dateadd.sql))
This macro adds a time/day interval to the supplied date/timestamp. Note: The `datepart` argument is database-specific.

Usage:
```
{{ dbt_utils.dateadd(datepart='day', interval=1, from_date_or_timestamp='2017-01-01') }}
```

#### datediff ([source](macros/cross_db_utils/datediff.sql))
This macro calculates the difference between two dates.

Usage:
```
{{ dbt_utils.datediff("'2018-01-01'", "'2018-01-20'", 'day') }}
```


#### split_part ([source](macros/cross_db_utils/split_part.sql))
This macro splits a string of text using the supplied delimiter and returns the supplied part number (1-indexed).

Usage:
```
{{ dbt_utils.split_part(string_text='1,2,3', delimiter_text=',', part_number=1) }}
```

#### date_trunc ([source](macros/cross_db_utils/date_trunc.sql))
Truncates a date or timestamp to the specified datepart. Note: The `datepart` argument is database-specific.

Usage:
```
{{ dbt_utils.date_trunc(datepart, date) }}
```

#### last_day ([source](macros/cross_db_utils/last_day.sql))
Gets the last day for a given date and datepart. Notes:

- The `datepart` argument is database-specific.
- This macro currently only supports dateparts of `month` and `quarter`.

Usage:
```
{{ dbt_utils.last_day(date, datepart) }}
```
---
### Date/Time
#### date_spine ([source](macros/datetime/date_spine.sql))
This macro returns the sql required to build a date spine.

Usage:
```
{{ dbt_utils.date_spine(
    datepart="minute",
    start_date="to_date('01/01/2016', 'mm/dd/yyyy')",
    end_date="dateadd(week, 1, current_date)"
   )
}}
```
---
### Geo
#### haversine_distance ([source](macros/geo/haversine_distance.sql))
This macro calculates the [haversine distance](http://daynebatten.com/2015/09/latitude-longitude-distance-sql/) between a pair of x/y coordinates.

Usage:
```
{{ dbt_utils.haversine_distance(lat1=<float>,lon1=<float>,lat2=<float>,lon2=<float>) }}
```
---
### Schema Tests
#### equal_rowcount ([source](macros/schema_tests/equal_rowcount.sql))
This schema test asserts the that two relations have the same number of rows.

Usage:
```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.equal_rowcount:
          compare_model: ref('other_table_name')

```

#### equality ([source](macros/schema_tests/equality.sql))
This schema test asserts the equality of two relations.

Usage:
```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.equality:
          compare_model: ref('other_table_name')

```

#### expression_is_true ([source](macros/schema_tests/expression_is_true.sql))
This schema test asserts that a valid sql expression is true for all records. This is useful when checking integrity across columns, for example, that a total is equal to the sum of its parts, or that at least one column is true.

Usage:
```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.expression_is_true:
          expression: "col_a + col_b = total"

```

The macro accepts an optional parameter `condition` that allows for asserting
the `expression` on a subset of all records.

Usage:
```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.expression_is_true:
          expression: "col_a + col_b = total"
          condition: "created_at > '2018-12-31'"

```


#### recency ([source](macros/schema_tests/recency.sql))
This schema test asserts that there is data in the referenced model at least as recent as the defined interval prior to the current timestamp.

Usage:
```yaml
version: 2

models:
  - name: model_name
    tests:
      - dbt_utils.recency:
          datepart: day
          field: created_at
          interval: 1
```

#### at_least_one ([source](macros/schema_tests/at_least_one.sql))
This schema test asserts if column has at least one value.

Usage:
```yaml
version: 2

models:
  - name: model_name
    columns:
      - name: col_name
        tests:
          - dbt_utils.at_least_one


```

#### not_constant ([source](macros/schema_tests/not_constant.sql))
This schema test asserts if column does not have same value in all rows.

Usage:
```yaml
version: 2

models:
  - name: model_name
    columns:
      - name: column_name
        tests:
          - dbt_utils.not_constant

```

#### cardinality_equality ([source](macros/schema_tests/cardinality_equality.sql))
This schema test asserts if values in a given column have exactly the same cardinality as values from a different column in a different model.

Usage:
```yaml
version: 2

models:
  - name: model_name
    columns:
      - name: from_column
        tests:
          - dbt_utils.cardinality_equality:
              field: other_column_name
              to: ref('other_model_name')

```

---
### SQL helpers
#### get_column_values ([source](macros/sql/get_column_values.sql))
This macro returns the unique values for a column in a given table.

Usage:
```
-- Returns a list of the top 50 states in the `users` table
{% set states = dbt_utils.get_column_values(table=ref('users'), column='state', max_records=50) %}

{% for state in states %}
    ...
{% endfor %}

...
```

#### get_tables_by_prefix ([source](macros/sql/get_tables_by_prefix.sql))
This macro returns a list of tables that match a given prefix, with an optional
exclusion pattern. It's particularly handy paired with `union_tables`.

Usage:
```
-- Returns a list of tables that match schema.prefix%
{{ set tables = dbt_utils.get_tables_by_prefix('schema', 'prefix')}}

-- Returns a list of tables as above, excluding any with underscores
{{ set tables = dbt_utils.get_tables_by_prefix('schema', 'prefix', '%_%')}}
```

#### group_by ([source](macros/sql/groupby.sql))
This macro build a group by statement for fields 1...N

Usage:
```
{{ dbt_utils.group_by(n=3) }} --> group by 1,2,3
```

#### star ([source](macros/sql/star.sql))
This macro generates a list of all fields that exist in the `from` relation, excluding any fields listed in the `except` argument. The construction is identical to `select * from {{ref('my_model')}}`, replacing star (`*`) with the star macro. This macro also has an optional `relation_alias` argument that will prefix all generated fields with an alias.

Usage:
```
select
{{ dbt_utils.star(from=ref('my_model'), except=["exclude_field_1", "exclude_field_2"]) }}
from {{ref('my_model')}}
```

#### union_tables ([source](macros/sql/union.sql))
This macro implements an "outer union." The list of relations provided to this macro will be unioned together, and any columns exclusive to a subset of these tables will be filled with `null` where not present. The `column_override` argument is used to explicitly assign the column type for a set of columns. The `source_column_name` argument is used to change the name of the`_dbt_source_table` field.

Usage:
```
{{ dbt_utils.union_tables(
    tables=[ref('table_1'), ref('table_2')],
    column_override={"some_field": "varchar(100)"},
    exclude=["some_other_field"],
    source_column_name='custom_source_column_name'
) }}
```

#### generate_series ([source](macros/sql/generate_series.sql))
This macro implements a cross-database mechanism to generate an arbitrarily long list of numbers. Specify the maximum number you'd like in your list and it will create a 1-indexed SQL result set.

Usage:
```
{{ dbt_utils.generate_series(upper_bound=1000) }}
```

#### surrogate_key ([source](macros/sql/surrogate_key.sql))
Implements a cross-database way to generate a hashed surrogate key using the fields specified.

Usage:
```
{{ dbt_utils.surrogate_key('field_a', 'field_b'[,...]) }}
```

#### pivot ([source](macros/sql/pivot.sql))
This macro pivots values from rows to columns.

Usage:
```
{{ dbt_utils.pivot(<column>, <list of values>) }}
```

Example:

    Input: public.test

    | size | color |
    |------|-------|
    | S    | red   |
    | S    | blue  |
    | S    | red   |
    | M    | red   |

    select
      size,
      {{ dbt_utils.pivot('color', dbt_utils.get_column_values('public.test',
                                                             'color')) }}
    from public.test
    group by size

    Output:

    | size | red | blue |
    |------|-----|------|
    | S    | 2   | 1    |
    | M    | 1   | 0    |

Arguments:

    - column: Column name, required
    - values: List of row values to turn into columns, required
    - alias: Whether to create column aliases, default is True
    - agg: SQL aggregation function, default is sum
    - cmp: SQL value comparison, default is =
    - prefix: Column alias prefix, default is blank
    - suffix: Column alias postfix, default is blank
    - then_value: Value to use if comparison succeeds, default is 1
    - else_value: Value to use if comparison fails, default is 0
    - quote_identifiers: Whether to surround column aliases with double quotes, default is true

#### unpivot ([source](macros/sql/unpivot.sql))
This macro "un-pivots" a table from wide format to long format. Functionality is similar to pandas [melt](http://pandas.pydata.org/pandas-docs/stable/generated/pandas.melt.html) function.

Usage:
```
{{ dbt_utils.unpivot(table=ref('table_name'), cast_to='datatype', exclude=[<list of columns to exclude from unpivot>], remove=[<list of columns to remove>], field_name=<column name for field>, value_name=<column name for value>) }}
```

Example:

    Input: orders

    | date       | size | color | status     |
    |------------|------|-------|------------|
    | 2017-01-01 | S    | red   | complete   |
    | 2017-03-01 | S    | red   | processing |

    {{ dbt_utils.unpivot(ref('orders'), cast_to='varchar', exclude=['date','status']) }}

    Output:

    | date       | status     | field_name | value |
    |------------|------------|------------|-------|
    | 2017-01-01 | complete   | size       | S     |
    | 2017-01-01 | complete   | color      | red   |
    | 2017-03-01 | processing | size       | S     |
    | 2017-03-01 | processing | color      | red   |

Arguments:

    - table: Table name, required
    - cast_to: The data type to cast the unpivoted values to, default is varchar
    - exclude: A list of columns to exclude from the unpivot operation but keep in the resulting table.
    - remove: A list of columns to remove from the resulting table.
    - field_name: column name in the resulting table for field
    - value_name: column name in the resulting table for value

---
### Web
#### get_url_parameter ([source](macros/web/get_url_parameter.sql))
This macro extracts a url parameter from a column containing a url.

Usage:
```
{{ dbt_utils.get_url_parameter(field='page_url', url_parameter='utm_source') }}
```

#### get_url_host ([source](macros/web/get_url_host.sql))
This macro extracts a hostname from a column containing a url.

Usage:
```
{{ dbt_utils.get_url_host(field='page_url') }}
```

#### get_url_path ([source](macros/web/get_url_path.sql))
This macro extracts a page path from a column containing a url.

Usage:
```
{{ dbt_utils.get_url_host(field='page_url') }}
```

---
### Materializations
#### insert_by_period ([source](macros/materializations/insert_by_period_materialization.sql))
`insert_by_period` allows dbt to insert records into a table one period (i.e. day, week) at a time.

This materialization is appropriate for event data that can be processed in discrete periods. It is similar in concept to the built-in incremental materialization, but has the added benefit of building the model in chunks even during a full-refresh so is particularly useful for models where the initial run can be problematic.

Should a run of a model using this materialization be interrupted, a subsequent run will continue building the target table from where it was interrupted (granted the `--full-refresh` flag is omitted).

Progress is logged in the command line for easy monitoring.

Usage:
```sql
{{
  config(
    materialized = "insert_by_period",
    period = "day",
    timestamp_field = "created_at",
    start_date = "2018-01-01",
    stop_date = "2018-06-01")
}}

with events as (

  select *
  from {{ ref('events') }}
  where __PERIOD_FILTER__ -- This will be replaced with a filter in the materialization code

)

....complex aggregates here....

```
Configuration values:
* `period`: period to break the model into, must be a valid [datepart](https://docs.aws.amazon.com/redshift/latest/dg/r_Dateparts_for_datetime_functions.html) (default='Week')
* `timestamp_field`: the column name of the timestamp field that will be used to break the model into smaller queries
* `start_date`: literal date or timestamp - generally choose a date that is earlier than the start of your data
* `stop_date`: literal date or timestamp (default=current_timestamp)

Caveats:
* This materialization is compatible with dbt 0.10.1.
* This materialization has been written for Redshift.
* This materialization can only be used for a model where records are not expected to change after they are created.
* Any model post-hooks that use `{{ this }}` will fail using this materialization. For example:
```yaml
models:
    project-name:
        post-hook: "grant select on {{ this }} to db_reader"
```
A useful workaround is to change the above post-hook to:
```yaml
        post-hook: "grant select on {{ this.schema }}.{{ this.name }} to db_reader"
```

----

### Contributing

We welcome contributions to this repo! To contribute a new feature or a fix, please open a Pull Request with 1) your changes, 2) updated documentation for the `README.md` file, and 3) a working integration test. See [this page](integration_tests/README.md) for more information.

----

### Getting started with dbt

- [What is dbt]?
- Read the [dbt viewpoint]
- [Installation]
- Join the [chat][slack-url] on Slack for live questions and support.


## Code of Conduct

Everyone interacting in the dbt project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [PyPA Code of Conduct].



[PyPA Code of Conduct]: https://www.pypa.io/en/latest/code-of-conduct/
[slack-url]: http://ac-slackin.herokuapp.com/
[Installation]: https://dbt.readme.io/docs/installation
[What is dbt]: https://dbt.readme.io/docs/overview
[dbt viewpoint]: https://dbt.readme.io/docs/viewpoint
