# dbt-utils v0.6.5
## Features
* Add new `accepted_range` test ([#276](https://github.com/fishtown-analytics/dbt-utils/pull/276) [@joellabes](https://github.com/joellabes))
* Make `expression_is_true` work as a column test (code originally in [#226](https://github.com/fishtown-analytics/dbt-utils/pull/226/) from [@elliottohara](https://github.com/elliottohara), merged via [#313])
* Add new schema test, `not_accepted_values` ([#284](https://github.com/fishtown-analytics/dbt-utils/pull/284) [@JavierMonton](https://github.com/JavierMonton))
* Support a new argument, `zero_length_range_allowed` in the `mutually_exclusive_ranges` test ([#307](https://github.com/fishtown-analytics/dbt-utils/pull/307) [@zemekeng](https://github.com/zemekeneng))
* Add new schema test, `sequential_values` ([#318](https://github.com/fishtown-analytics/dbt-utils/pull/318), inspired by [@hundredwatt](https://github.com/hundredwatt))
* Support `quarter` in the `postgres__last_day` macro ([#333](https://github.com/fishtown-analytics/dbt-utils/pull/333/files), [@seunghanhong](https://github.com/seunghanhong))
* Add new argument, `unit`, to `haversine_distance` [#340](https://github.com/fishtown-analytics/dbt-utils/pull/340) [@bastienboutonnet](https://github.com/bastienboutonnet)
* Add new schema test, `fewer_rows_than` (code originally in [#221](https://github.com/fishtown-analytics/dbt-utils/pull/230/) from [@dmarts](https://github.com/dmarts), merged via [#343])


## Fixes
* Handle booleans gracefully in the unpivot macro ([#305](https://github.com/fishtown-analytics/dbt-utils/pull/305) [@avishalom](https://github.com/avishalom))
* Fix a bug in `get_relation_by_prefix` that happens with Snowflake external tables. Now the macro will retrieve tables that match the prefix which are external tables ([#350](https://github.com/fishtown-analytics/dbt-utils/issues/350))
* Fix `cardinality_equality` test when the two tables' column names differed ([#334](https://github.com/fishtown-analytics/dbt-utils/pull/334)) [@joellabes](https://github.com/joellabes)

## Under the hood
* Fix Markdown formatting for hub rendering ([#336](https://github.com/fishtown-analytics/dbt-utils/issues/350), [@coapacetic](https://github.com/coapacetic))
* Reorder readme and improve docs

# dbt-utils v0.6.4

### Fixes
- Fix `insert_by_period` to support `dbt v0.19.0`, with backwards compatibility for earlier versions ([#319](https://github.com/fishtown-analytics/dbt-utils/pull/319), [#320](https://github.com/fishtown-analytics/dbt-utils/pull/320))

### Under the hood
- Speed up CI via threads, workflows ([#315](https://github.com/fishtown-analytics/dbt-utils/pull/315), [#316](https://github.com/fishtown-analytics/dbt-utils/pull/316))
- Fix `equality` test when used with ephemeral models + explicit column set ([#321](https://github.com/fishtown-analytics/dbt-utils/pull/321))
- Fix `get_query_results_as_dict` integration test with consistent ordering ([#322](https://github.com/fishtown-analytics/dbt-utils/pull/322))
- All macros are now properly dispatched, making it possible for non-core adapters to implement a shim package for dbt-utils ([#312](https://github.com/fishtown-analytics/dbt-utils/pull/312)) Thanks [@chaerinlee1](https://github.com/chaerinlee1) and [@swanderz](https://github.com/swanderz)
- Small, non-breaking changes to accomodate TSQL (can't group by column number references, no real TRUE/FALSE values, aggregation CTEs need named columns) ([#310](https://github.com/fishtown-analytics/dbt-utils/pull/310)) Thanks [@swanderz](https://github.com/swanderz)
- Make `get_relations_by_pattern` and `get_relations_by_prefix` more powerful by returning `relation.type` ([#323](https://github.com/fishtown-analytics/dbt-utils/pull/323))

# dbt-utils v0.6.3

- Bump `require-dbt-version` to `[">=0.18.0", "<0.20.0"]` to support dbt v0.19.0 ([#308](https://github.com/fishtown-analytics/dbt-utils/pull/308), [#309](https://github.com/fishtown-analytics/dbt-utils/pull/309))

# dbt-utils v0.6.2

## Fixes
- Fix the logic in `get_tables_by_pattern_sql` to ensure non-default arguments are respected ([#279](https://github.com/fishtown-analytics/dbt-utils/pull/279))


# dbt-utils v0.6.1

## Fixes
- Fix the logic in `get_tables_by_pattern_sql` for matching a schema pattern on BigQuery ([#275](https://github.com/fishtown-analytics/dbt-utils/pull/275/))

# dbt-utils v0.6.0

## Breaking changes
- :rotating_light: dbt v0.18.0 or greater is required for this release. If you are not ready to upgrade, consider using a previous release of this package
- :rotating_light: The `get_tables_by_prefix`, `union_tables` and `get_tables_by_pattern` macros have been removed

## Migration instructions
- Upgrade your dbt project to v0.18.0 using [these instructions](https://discourse.getdbt.com/t/prerelease-v0-18-0-marian-anderson/1545).
- Upgrade your `packages.yml` file to use version `0.6.0` of this package. Run `dbt clean` and `dbt deps`.
- If your project uses the `get_tables_by_prefix` macro, replace it with `get_relations_by_prefix`. All arguments have retained the same name.
- If your project uses the `union_tables` macro, replace it with `union_relations`. While the order of arguments has stayed consistent, the `tables` argument has been renamed to `relations`. Further, the default value for the `source_column_name` argument has changed from `'_dbt_source_table'` to `'_dbt_source_relation'` — you may want to explicitly define this argument to avoid breaking changes.

```
-- before:
{{ dbt_utils.union_tables(
    tables=[ref('my_model'), source('my_source', 'my_table')],
    exclude=["_loaded_at"]
) }}

-- after:
{{ dbt_utils.union_relations(
    relations=[ref('my_model'), source('my_source', 'my_table')],
    exclude=["_loaded_at"],
    source_column_name='_dbt_source_table'
) }}
```
- If your project uses the `get_tables_by_pattern` macro, replace it with `get_tables_by_pattern_sql` — all arguments are consistent.

## Features

* Switch usage of `adapter_macro` to `adapter.dispatch`, and define `dbt_utils_dispatch_list`,
enabling users of community-supported database plugins to add or override macro implementations
specific to their database ([#267](https://github.com/fishtown-analytics/dbt-utils/pull/267))
* Use `add_ephemeral_prefix` instead of hard-coding a string literal, to support
database adapters that use different prefixes ([#267](https://github.com/fishtown-analytics/dbt-utils/pull/267))
* Implement a quote_columns argument in the unique_combination_of_columns schema test ([#270](https://github.com/fishtown-analytics/dbt-utils/pull/270) [@JoshuaHuntley](https://github.com/JoshuaHuntley))

## Quality of life
* Remove deprecated macros `get_tables_by_prefix` and `union_tables` ([#268](https://github.com/fishtown-analytics/dbt-utils/pull/268))
* Remove `get_tables_by_pattern` macro, which is equivalent to the `get_tables_by_pattern_sql` macro (the latter has a more logical name) ([#268](https://github.com/fishtown-analytics/dbt-utils/pull/268))

# dbt-utils v0.5.1

## Quality of life
* Improve release process, and fix tests ([#251](https://github.com/fishtown-analytics/dbt-utils/pull/251))
* Make deprecation warnings more useful ([#258](https://github.com/fishtown-analytics/dbt-utils/pull/258) [@tayloramurphy](https://github.com/tayloramurphy))
* Add more docs for `date_spine` ([#265](https://github.com/fishtown-analytics/dbt-utils/pull/265) [@calvingiles](https://github.com/calvingiles))
