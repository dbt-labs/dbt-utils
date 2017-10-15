<p align="center">
  <img src="etc/dbt-logo.png" alt="dbt logo" />
</p>

----

# dbt-utils

Current version: 0.1.0

This package contains macros that can be (re)used across dbt projects.

## Macros
### Cross-database
#### current_timestamp ([source](macros/cross_db_utils/current_timestamp.sql))
This macro returns the current timestamp.

Usage:
```
{{ current_timestamp() }}
```

#### dateadd ([source](macros/cross_db_utils/dateadd.sql))
This macro adds a time/day interval to the supplied date/timestamp. Note: The `datepart` argument is database-specific.

Usage:
```
{{ dateadd(datepart='day', interval=1, from_date_or_timestamp='2017-01-01') }}
```

#### split_part ([source](macros/cross_db_utils/split_part.sql))
This macro adds a time/day interval to the supplied date/timestamp. Note: The `datepart` argument is database-specific.

Usage:
```
{{ split_part(string_text='1,2,3', delimiter_text=',', part_number=1) }}
```
---
### Date/Time
#### date_spine ([source](macros/datetime/date_spine.sql))
This macro returns the sql required to build a date spine.

Usage:
```
{{ date_spine(
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
{{ haversine_distance(lat1=<float>,lon1=<float>,lat2=<float>,lon2=<float>) }}
```
---
### Schema Tests
#### equality ([source](macros/schema_tests/equality.sql))
This schema test asserts the equality of two relations.

Usage:
```
model_name:
  constraints:
    equality:
      - ref('other_table_name')

```
---
### SQL helpers
#### group_by ([source](macros/sql/groupby.sql))
This macro build a group by statement for fields 1...N

Usage:
```
{{ group_by(n=3) }} --> group by 1,2,3
```

#### star ([source](macros/sql/star.sql))
This macro generates a `select` statement for each field that exists in the `from` relation. Fields listed in the `except` argument will be excluded from this list.

Usage:
```
{{ star(from=ref('my_model'), except=["exclude_field_1", "exclude_field_2"]) }}
```

#### union_tables ([source](macros/sql/union.sql))
This macro implements an "outer union." The list of tables provided to this macro will be unioned together, and any columns exclusive to a subset of these tables will be filled with `null` where not present. The `column_override` argument is used to explicitly assign the column type for a set of columns.

Usage:
```
{{ union_tables(tables=[ref('table_1'), ref('table_2')], column_override={"some_field": "varchar(100)"}) }}
```

#### get_column_values ([source](macros/sql/pivot.sql))
This macro returns the unique values for a column in a given table.

Usage:
```
-- Returns a list of the top 50 states in the `users` table
{% states = fromjson(get_column_values(table=ref('users'), column='state', max_records=50)) %}

...
```
---
### Web
#### get_url_parameter ([source](macros/web/get_url_parameter.sql))
This macro extracts a url parameter from a column containing a url.

Usage:
```
{{ get_url_parameter(field='page_url', url_parameter='utm_source') }}
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
