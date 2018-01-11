<p align="center">
  <img src="etc/dbt-logo.png" alt="dbt logo" />
</p>

----

# dbt-utils

This package contains macros that can be (re)used across dbt projects. To use these macros, add this package as a dependency in your `dbt_project.yml` file:

```yml
repositories:
    # Be sure to replace VERSION_NUMBER below!
    - https://github.com/fishtown-analytics/dbt-utils.git@VERSION_NUMBER
```

It's a good practice to "tag" your dependencies with version numbers. You can find the latest release of this package [here](https://github.com/fishtown-analytics/dbt-utils/tags).

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

#### split_part ([source](macros/cross_db_utils/split_part.sql))
This macro adds a time/day interval to the supplied date/timestamp. Note: The `datepart` argument is database-specific.

Usage:
```
{{ dbt_utils.split_part(string_text='1,2,3', delimiter_text=',', part_number=1) }}
```
---
### Date/Time
#### date_spine ([source](macros/datetime/date_spine.sql))
This macro returns the sql required to build a date spine.

Usage:
```
{{ dbt_utils.date_spine(
    table=ref('organizations'),
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
#### equality ([source](macros/schema_tests/equality.sql))
This schema test asserts the equality of two relations.

Usage:
```
model_name:
  constraints:
    dbt_utils.equality:
      - ref('other_table_name')

```

#### recency ([source](macros/schema_tests/recency.sql))
This schema test asserts that there is data in the referenced model at least as recent as the defined interval prior to the current timestamp.

Usage:
```
model_name:
    constraints:
        dbt_utils.recency:
            - {field: created_at, datepart: day, interval: 1}
```

#### at_least_one ([source](macros/schema_tests/at_least_one.sql))
This schema test asserts if column has at least one value.

Usage:
```
model_name:
  constraints:
    dbt_utils.at_least_one:
      - column_name

```

#### not_constant ([source](macros/schema_tests/not_constant.sql))
This schema test asserts if column does not have same value in all rows.

Usage:
```
model_name:
  constraints:
    dbt_utils.not_constant:
      - column_name

```

#### cardinality_equality ([source](macros/schema_tests/cardinality_equality.sql))
This schema test asserts if values in a given column have exactly the same cardinality as values from a different column in a different model.

Usage:
```
model_name:
  constraints:
    dbt_utils.cardinality_equality:
    - {from: column_name, to: ref('other_model_name'), field: other_column_name}
```

---
### SQL helpers
#### get_column_values ([source](macros/sql/get_column_values.sql))
This macro returns the unique values for a column in a given table.

Usage:
```
-- Returns a list of the top 50 states in the `users` table
{% set states = fromjson(dbt_utils.get_column_values(table=ref('users'), column='state', max_records=50)) %}

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
This macro generates a `select` statement for each field that exists in the `from` relation. Fields listed in the `except` argument will be excluded from this list.

Usage:
```
{{ dbt_utils.star(from=ref('my_model'), except=["exclude_field_1", "exclude_field_2"]) }}
```

#### union_tables ([source](macros/sql/union.sql))
This macro implements an "outer union." The list of tables provided to this macro will be unioned together, and any columns exclusive to a subset of these tables will be filled with `null` where not present. The `column_override` argument is used to explicitly assign the column type for a set of columns.

Usage:
```
{{ dbt_utils.union_tables(tables=[ref('table_1'), ref('table_2')], column_override={"some_field": "varchar(100)"}) }}
```

#### generate_series ([source](macros/sql/generate_series.sql))
This macro implements a cross-database mechanism to generate an arbitrarily long list of numbers. Specify the maximum number you'd like in your list and it will create a 1-indexed SQL result set.

Usage:
```
{{ dbt_utils.generate_series(upper_bound=1000) }}
```
---
### Web
#### get_url_parameter ([source](macros/web/get_url_parameter.sql))
This macro extracts a url parameter from a column containing a url.

Usage:
```
{{ dbt_utils.get_url_parameter(field='page_url', url_parameter='utm_source') }}
```

---
### Strings
#### lower_alpha ([source](macros/strings/lower_alpha.sql))
This macro removes any non-alphanumeric characters and reverts all characters to lower case.

Usage:
```
{{ lower_alpha(arg='email_address') }}
```

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
