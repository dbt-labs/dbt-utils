<!--- Copy, paste, and uncomment the following headers as-needed for unreleased features
# Unreleased
## New features
- XXX ([#XXX](https://github.com/dbt-labs/dbt-utils/issues/XXX), [#XXX](https://github.com/dbt-labs/dbt-utils/pull/XXX))
## Fixes
## Quality of life
## Under the hood
## Contributors:
--->

# Unreleased
## New features
- XXX ([#XXX](https://github.com/dbt-labs/dbt-utils/issues/XXX), [#XXX](https://github.com/dbt-labs/dbt-utils/pull/XXX))
## Fixes
## Quality of life
## Under the hood
## Contributors:

# dbt utils v1.1.0
## What's Changed
### New functionality
* Safe subtract by @dchess in https://github.com/dbt-labs/dbt-utils/pull/748
* Add Databricks handler for get_table_types_sql.sql by @Harmuth94 in https://github.com/dbt-labs/dbt-utils/pull/769

### Documentation
* Typo fix by @AndrewLane in https://github.com/dbt-labs/dbt-utils/pull/738
* Removed remark about Dbt 0.9.6 as utils 1.0.0 is now the the default by @ilanbenb in https://github.com/dbt-labs/dbt-utils/pull/740
* Fix link in README by @b-per in https://github.com/dbt-labs/dbt-utils/pull/743
* Update README.md about use `where` with `accepted_range` tests by @eitsupi in https://github.com/dbt-labs/dbt-utils/pull/739
* doc: clarify that `union_relations()` uses `union all` by @owenprough-sift in https://github.com/dbt-labs/dbt-utils/pull/760
* Automatically generate TOC for utils readme by @joellabes in https://github.com/dbt-labs/dbt-utils/pull/486

### Behind the scenes
* Use CircleCI contexts for environment variables by @dbeatty10 in https://github.com/dbt-labs/dbt-utils/pull/754
* fix: #755 - add whitespace control to generate_surrogate_key macro by @akv-akv in https://github.com/dbt-labs/dbt-utils/pull/756
* Fix CI by @joellabes in https://github.com/dbt-labs/dbt-utils/pull/771

## New Contributors
* @AndrewLane made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/738
* @ilanbenb made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/740
* @eitsupi made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/739
* @owenprough-sift made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/760
* @akv-akv made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/756
* @dchess made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/748
* @Harmuth94 made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/769


# dbt utils v1.0

## Migration Guide 
The full migration guide is at https://docs.getdbt.com/guides/migration/versions/upgrading-to-dbt-utils-v1.0 

## New features
- New macro `get_single_value` ([#696](https://github.com/dbt-labs/dbt-utils/pull/696))
- New macro safe_divide() — Returns null when the denominator is 0, instead of throwing a divide-by-zero error.
- Add `not_empty_string` generic test that asserts column values are not an empty string. ([#632](https://github.com/dbt-labs/dbt-utils/issues/632), [#634](https://github.com/dbt-labs/dbt-utils/pull/634))

## Enhancements
- Implemented an optional `group_by_columns` argument across many of the generic testing macros to test for properties that only pertain to group-level or are can be more rigorously conducted at the group level. Property available in `recency`, `at_least_one`, `equal_row_count`, `fewer_rows_than`, `not_constant`, `not_null_proportion`, and `sequential` tests [#633](https://github.com/dbt-labs/dbt-utils/pull/633)
- With the addition of an on-by-default quote_identifiers flag in the star() macro, you can now disable quoting if necessary. ([#706](https://github.com/dbt-labs/dbt-utils/pull/706))

## Fixes
- `union()` now includes/excludes columns case-insensitively
- The `expression_is_true test` doesn’t output * unless storing failures, a cost improvement for BigQuery ([#683](https://github.com/dbt-labs/dbt-utils/issues/683), [#686](https://github.com/dbt-labs/dbt-utils/pull/686))
- Updated the `slugify` macro to prepend "_" to column names beginning with a number since most databases do not allow names to begin with numbers. 

## Under the hood
- Remove deprecated table argument from `unpivot` ([#671](https://github.com/dbt-labs/dbt-utils/pull/671))
- Delete the deprecated identifier macro ([#672](https://github.com/dbt-labs/dbt-utils/pull/672))
- Handle deprecations in deduplicate macro ([#673](https://github.com/dbt-labs/dbt-utils/pull/673))
- Fully remove varargs usage in `surrogate_key` and `safe_add` ([#674](https://github.com/dbt-labs/dbt-utils/pull/674))
- Remove obsolete condition argument from `expression_is_true` ([#699](https://github.com/dbt-labs/dbt-utils/pull/699))
- Explicitly stating the namespace for cross-db macros so that the dispatch logic works correctly by restoring the dbt. prefix for all migrated cross-db macros ([#701](https://github.com/dbt-labs/dbt-utils/pull/701))

## Contributors:
- [@CR-Lough] (https://github.com/CR-Lough) (#706) (#696)
- [@fivetran-catfritz](https://github.com/fivetran-catfritz)
- [@crowemi](https://github.com/crowemi)
- [@SimonQuvang](https://github.com/SimonQuvang) (#701)
- [@christineberger](https://github.com/christineberger) (#624)
- [@epapineau](https://github.com/epapineau) (#634)
- [@courentin](https://github.com/courentin) (#651)
- [@zachoj10](https://github.com/zachoj10) (#692)
- [@miles170](https://github.com/miles170)
- [@emilyriederer](https://github.com/emilyriederer)
# 0.9.5
## Fixes
- Stop showing cross-db deprecation warnings for macros who have already been migrated ([#725](https://github.com/dbt-labs/dbt-utils/pull/725))

## 0.9.3 and 0.9.4
Rolled back due to accidental incompatibilities
# dbt-utils 0.9.2
## What's Changed
* Remove unnecessary generated new lines in `star` by @courentin in https://github.com/dbt-labs/dbt-utils/pull/651
* fix: Actually suppress `union_relations` source_column_name when passing `none` by @kmclaugh in https://github.com/dbt-labs/dbt-utils/pull/661
* Make `mutually_exclusive_ranges`' test deterministic by adding `upper_bound_column` to `order by` clause by @sfc-gh-ancoleman in https://github.com/dbt-labs/dbt-utils/pull/660
* update union_relations to use core string literal macro by @dave-connors-3 in https://github.com/dbt-labs/dbt-utils/pull/665
* Add where clause example to get_column_values documentation by @arsenkhy in https://github.com/dbt-labs/dbt-utils/pull/623

## New Contributors
* @courentin made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/651
* @kmclaugh made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/661
* @sfc-gh-ancoleman made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/660
* @dave-connors-3 made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/665
* @arsenkhy made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/623

# dbt-utils 0.9.1
## Fixes
- Remove cross-db dbt_utils references by @clausherther in #650


# dbt-utils 0.9.0
## Changed functionality
* 🚨 (Almost all) cross-db macros are now implemented in dbt Core instead of dbt-utils. A backwards-compatibility layer remains for now and will be removed in dbt utils 1.0 later this year. Completed by @dbeatty10 and @jtcohen6 in https://github.com/dbt-labs/dbt-utils/pull/597, https://github.com/dbt-labs/dbt-utils/pull/586 and https://github.com/dbt-labs/dbt-utils/pull/615
  * See #487 for further discussion on the backstory
  * If you are a package maintainer with a dependency on these macros, prepare for their removal by switching to `{{ dbt.some_macro() }}`. Refer to [#package-ecosystem in the Community Slack](https://getdbt.slack.com/archives/CU4MRJ7QB/p1658467817852129) for further assistance
* Feature: Add option to remove the `source_column_name` on the `union_relations` macro by @christineberger in https://github.com/dbt-labs/dbt-utils/pull/624

## Fixes
* Use adapter.quote() instead of hardcoded BQ quoting for get_table_types_sql by @alla-bongard in https://github.com/dbt-labs/dbt-utils/pull/636

## Documentation
* standardize yml indentation under the 'models:' line on the README by @leoebfolsom in https://github.com/dbt-labs/dbt-utils/pull/613
* Use MADR 3.0.0 for formatting decision records by @dbeatty10 in https://github.com/dbt-labs/dbt-utils/pull/614
* Docs cleanup by @dbeatty10 in https://github.com/dbt-labs/dbt-utils/pull/620
* Add not_accepted_values to README ToC by @david-beallor in https://github.com/dbt-labs/dbt-utils/pull/646

# New Contributors
* @leoebfolsom made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/613
* @christineberger made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/624
* @alla-bongard made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/636
* @david-beallor made their first contribution in https://github.com/dbt-labs/dbt-utils/pull/646
# dbt-utils v0.8.6

## New features
- New macros `array_append` and `array_construct` ([#595](https://github.com/dbt-labs/dbt-utils/pull/595))

## Fixes
- Use `*` in `star` macro if no columns (for SQLFluff) ([#605](https://github.com/dbt-labs/dbt-utils/issues/605), [#561](https://github.com/dbt-labs/dbt-utils/pull/561))
- Only raise error within `union_relations` for `build`/`run` sub-commands ([#606](https://github.com/dbt-labs/dbt-utils/issues/606), [#607](https://github.com/dbt-labs/dbt-utils/pull/607))

## Quality of life
- Add slugify to list of Jinja Helpers ([#602](https://github.com/dbt-labs/dbt-utils/pull/602))

## Under the hood
- Fix `make test` for running integration tests locally ([#344](https://github.com/dbt-labs/dbt-utils/issues/344), [#564](https://github.com/dbt-labs/dbt-utils/issues/564), [#591](https://github.com/dbt-labs/dbt-utils/pull/591))

## Contributors:
- [@swanjson](https://github.com/swanjson) (#561)
- [@dataders](https://github.com/dataders) (#561)
- [@epapineau](https://github.com/epapineau) (#583)
- [@graciegoheen](https://github.com/graciegoheen) (#595)
- [@jeremyyeo](https://github.com/jeremyyeo) (#606)

# dbt-utils v0.8.5
## 🚨 deduplicate ([#542](https://github.com/dbt-labs/dbt-utils/pull/542), [#548](https://github.com/dbt-labs/dbt-utils/pull/548))

The call signature of `deduplicate` has changed. The previous call signature is marked as deprecated and will be removed in the next minor version.

- The `group_by` argument is now deprecated and replaced by `partition_by`.
- The `order_by` argument is now required.
- The `relation_alias` argument has been removed as the macro now supports `relation` as a string directly. If you were using `relation_alias` to point to a CTE previously then you can now pass the alias directly to `relation`.

Before:
```jinja
{% macro deduplicate(relation, group_by, order_by=none, relation_alias=none) -%}
...
{% endmacro %}
```

After:
```jinja
{% macro deduplicate(relation, partition_by, order_by) -%}
...
{% endmacro %}
```

## New features
- Add an optional `where` clause parameter to `get_column_values()` to filter values returned ([#511](https://github.com/dbt-labs/dbt-utils/issues/511), [#583](https://github.com/dbt-labs/dbt-utils/pull/583))
- Add `where` parameter to `union_relations` macro ([#554](https://github.com/dbt-labs/dbt-utils/pull/554))
- Add Postgres specific implementation of `deduplicate()` ([#548](https://github.com/dbt-labs/dbt-utils/pull/548))
- Add Snowflake specific implementation of `deduplicate()` ([#543](https://github.com/dbt-labs/dbt-utils/issues/543), [#548](https://github.com/dbt-labs/dbt-utils/pull/548))

## Fixes
- Fix `union_relations` `source_column_name` none option.
- Enable a negative part_number for `split_part()` ([#557](https://github.com/dbt-labs/dbt-utils/issues/557), [#559](https://github.com/dbt-labs/dbt-utils/pull/559))
- Make `exclude` case insensitive for `union_relations()` ([#578](https://github.com/dbt-labs/dbt-utils/issues/557), [#587](https://github.com/dbt-labs/dbt-utils/issues/587))

## Quality of life
- Documentation about listagg macro ([#544](https://github.com/dbt-labs/dbt-utils/issues/544), [#560](https://github.com/dbt-labs/dbt-utils/pull/560))
- Fix links to macro section in table of contents ([#555](https://github.com/dbt-labs/dbt-utils/pull/555))
- Use the ADR (Architectural Design Record) pattern for documenting significant decisions ([#573](https://github.com/dbt-labs/dbt-utils/pull/573))
- Contributing guide ([#574](https://github.com/dbt-labs/dbt-utils/pull/574))
- Add better documentation for `deduplicate()` ([#542](https://github.com/dbt-labs/dbt-utils/pull/542), [#548](https://github.com/dbt-labs/dbt-utils/pull/548))

## Under the hood
- Fail integration tests appropriately ([#540](https://github.com/dbt-labs/dbt-utils/issues/540), [#545](https://github.com/dbt-labs/dbt-utils/pull/545))
- Upgrade CircleCI postgres convenience image ([#584](https://github.com/dbt-labs/dbt-utils/issues/584), [#585](https://github.com/dbt-labs/dbt-utils/pull/585))
- Run test for `deduplicate` ([#579](https://github.com/dbt-labs/dbt-utils/issues/579), [#580](https://github.com/dbt-labs/dbt-utils/pull/580))
- Reduce warnings when executing integration tests ([#558](https://github.com/dbt-labs/dbt-utils/issues/558), [#581](https://github.com/dbt-labs/dbt-utils/pull/581))
- Framework for functional testing using `pytest` ([#588](https://github.com/dbt-labs/dbt-utils/pull/588))

## Contributors:
- [@graciegoheen](https://github.com/graciegoheen) (#560)
- [@judahrand](https://github.com/judahrand) (#548)
- [@clausherther](https://github.com/clausherther) (#555)
- [@LewisDavies](https://github.com/LewisDavies) (#554)
- [@epapineau](https://github.com/epapineau) (#583)
- [@b-per](https://github.com/b-per) (#559)
- [@dbeatty10](https://github.com/dbeatty10), [@jeremyyeo](https://github.com/jeremyyeo) (#587)

# dbt-utils v0.8.4
## Fixes
- Change from quotes to backticks for BQ ([#536](https://github.com/dbt-labs/dbt-utils/issues/536), [#537](https://github.com/dbt-labs/dbt-utils/pull/537))

# dbt-utils v0.8.3
## New features
- A macro for deduplicating data, `deduplicate()` ([#335](https://github.com/dbt-labs/dbt-utils/issues/335), [#512](https://github.com/dbt-labs/dbt-utils/pull/512))
- A cross-database implementation of `listagg()` ([#530](https://github.com/dbt-labs/dbt-utils/pull/530))
- A new macro to get the columns in a relation as a list, `get_filtered_columns_in_relation()`. This is similar to the `star()` macro, but creates a Jinja list instead of a comma-separated string. ([#516](https://github.com/dbt-labs/dbt-utils/pull/516))

## Fixes
- `get_column_values()` once more raises an error when the model doesn't exist and there is no default provided ([#531](https://github.com/dbt-labs/dbt-utils/issues/531), [#533](https://github.com/dbt-labs/dbt-utils/pull/533))
- `get_column_values()` raises an error when used with an ephemeral model, instead of getting stuck in a compilation loop ([#358](https://github.com/dbt-labs/dbt-utils/issues/358), [#518](https://github.com/dbt-labs/dbt-utils/pull/518))
- BigQuery materialized views work correctly with `get_relations_by_pattern()` ([#525](https://github.com/dbt-labs/dbt-utils/pull/525))

## Quality of life
- Updated references to 'schema test' in project file structure and documentation ([#485](https://github.com/dbt-labs/dbt-utils/issues/485), [#521](https://github.com/dbt-labs/dbt-utils/pull/521))
- `date_trunc()` and `datediff()` default macros now have whitespace control to assist with linting and readability [#529](https://github.com/dbt-labs/dbt-utils/pull/529)
- `star()` no longer raises an error during SQLFluff linting ([#506](https://github.com/dbt-labs/dbt-utils/issues/506), [#532](https://github.com/dbt-labs/dbt-utils/pull/532))

## Contributors:
- [@judahrand](https://github.com/judahrand) (#512)
- [@b-moynihan](https://github.com/b-moynihan) (#521)
- [@sunriselong](https://github.com/sunriselong) (#529)
- [@jpmmcneill](https://github.com/jpmmcneill) (#533)
- [@KamranAMalik](https://github.com/KamranAMalik) (#532)
- [@graciegoheen](https://github.com/graciegoheen) (#530)
- [@luisleon90](https://github.com/luisleon90) (#525)
- [@epapineau](https://github.com/epapineau) (#518)
- [@patkearns10](https://github.com/patkearns10) (#516)

# dbt-utils v0.8.2
## Fixes
- Fix union_relations error from [#473](https://github.com/dbt-labs/dbt-utils/pull/473) when no include/exclude parameters are provided ([#505](https://github.com/dbt-labs/dbt-utils/issues/505), [#509](https://github.com/dbt-labs/dbt-utils/pull/509))

# dbt-utils v0.8.1
## New features
- A cross-database implementation of `any_value()` ([#497](https://github.com/dbt-labs/dbt-utils/issues/497), [#501](https://github.com/dbt-labs/dbt-utils/pull/501))
- A cross-database implementation of `bool_or()` ([#504](https://github.com/dbt-labs/dbt-utils/pull/504))

## Under the hood
- also ignore `dbt_packages/` directory [#463](https://github.com/dbt-labs/dbt-utils/pull/463)
- Remove block comments to make date_spine macro compatible with the Athena connector ([#462](https://github.com/dbt-labs/dbt-utils/pull/462))

## Fixes
- `type_timestamp` macro now explicitly casts postgres and redshift warehouse timestamp data types as `timestamp without time zone`, to be consistent with Snowflake behaviour (`timestamp_ntz`).
- `union_relations` macro will now raise an exception if the use of `include` or `exclude` results in no columns ([#473](https://github.com/dbt-labs/dbt-utils/pull/473), [#266](https://github.com/dbt-labs/dbt-utils/issues/266)).
- `get_relations_by_pattern()` works with foreign data wrappers on Postgres again. ([#357](https://github.com/dbt-labs/dbt-utils/issues/357), [#476](https://github.com/dbt-labs/dbt-utils/pull/476))
- `star()` will only alias columns if a prefix/suffix is provided, to allow the unmodified output to still be used in `group by` clauses etc. [#468](https://github.com/dbt-labs/dbt-utils/pull/468)
- The `sequential_values` test is now compatible with quoted columns [#479](https://github.com/dbt-labs/dbt-utils/pull/479)
- `pivot()` escapes values containing apostrophes [#503](https://github.com/dbt-labs/dbt-utils/pull/503)

## Contributors:
- [grahamwetzler](https://github.com/grahamwetzler) (#473)
- [Aesthet](https://github.com/Aesthet) (#476)
- [Kamitenshi](https://github.com/Kamitenshi) (#462)
- [nickperrott](https://github.com/nickperrott) (#468)
- [jelstongreen](https://github.com/jelstongreen) (#468)
- [armandduijn](https://github.com/armandduijn) (#479)
- [mdutoo](https://github.com/mdutoo) (#503)

# dbt-utils v0.8.0
## 🚨 Breaking changes
- dbt ONE POINT OH is here! This version of dbt-utils requires _any_ version (minor and patch) of v1, which means far less need for compatibility releases in the future.
- The partition column in the `mutually_exclusive_ranges` test is now always called `partition_by_col`. This enables compatibility with `--store-failures` when multiple columns are concatenated together. If you have models built on top of the failures table, update them to reflect the new column name. ([#423](https://github.com/dbt-labs/dbt-utils/issues/423), [#430](https://github.com/dbt-labs/dbt-utils/pull/430))

## Contributors:
- [codigo-ergo-sum](https://github.com/codigo-ergo-sum) (#430)

# dbt-utils 0.7.5
🚨 This is a compatibility release in preparation for `dbt-core` v1.0.0 (🎉). Projects using dbt-utils 0.7.4 with dbt-core v1.0.0 can expect to see a deprecation warning. This will be resolved in dbt_utils v0.8.0.

## Fixes
- Regression in `get_column_values()` where the default would not be respected if the model didn't exist. ([#444](https://github.com/dbt-labs/dbt-utils/issues/444), [#448](https://github.com/dbt-labs/dbt-utils/pull/448))

## Under the hood
- get_url_host() macro now correctly handles URLs beginning with android-app:// (#426)

## Contributors:
- [foundinblank](https://github.com/foundinblank)

# dbt-utils v0.7.4
## Fixes
- `get_column_values()` now works correctly with mixed-quoting styles on Snowflake ([#424](https://github.com/dbt-labs/dbt-utils/issues/424), [#440](https://github.com/dbt-labs/dbt-utils/pull/440))
- Remove extra semicolon in `insert_by_period` materialization that was causing errors ([#439](https://github.com/dbt-labs/dbt-utils/pull/439))
- Swap `limit 0` out for `{{ limit_zero() }}` on the `slugify()` tests to allow for compatibility with [tsql-utils](https://github.com/dbt-msft/tsql-utils) ([#437](https://github.com/dbt-labs/dbt-utils/pull/437))

## Contributors:
- [sean-rose](https://github.com/sean-rose)
- [@swanderz](https://github.com/swanderz)


# dbt-utils v0.7.4b1
:rotating_light:🚨 We have renamed the `master` branch to `main`. If you have a local version of `dbt-utils`, you will need to update to the new branch. See the [GitHub docs](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository/renaming-a-branch#updating-a-local-clone-after-a-branch-name-changes) for more details.

## Under the hood
- Bump `require-dbt-version` to have an upper bound of `'<=1.0.0'`.
- Url link fixes within the README for `not_constant`, `dateadd`, `datediff` and updated the header `Logger` to `Jinja Helpers`. ([#431](https://github.com/dbt-labs/dbt-utils/pull/431))
- Fully qualified a `cte_name.*` in the `equality` test to avoid an Exasol error ([#420](https://github.com/dbt-labs/dbt-utils/pull/420))
- `get_url_host()` macro now correctly handles URLs beginning with `android-app://` ([#426](https://github.com/dbt-labs/dbt-utils/pull/426))

## Contributors:
- [joemarkiewicz](https://github.com/fivetran-joemarkiewicz)
- [TimoKruth](https://github.com/TimoKruth)
- [foundinblank](https://github.com/foundinblank)

# dbt-utils v0.7.3

## Under the hood

- Fix bug introduced in 0.7.2 in dbt_utils.star which could cause the except argument to drop columns that were not explicitly specified ([#418](https://github.com/dbt-labs/dbt-utils/pull/418))
- Remove deprecated argument from not_null_proportion ([#416](https://github.com/dbt-labs/dbt-utils/pull/416))
- Change final select statement in not_null_proportion to avoid false positive failures ([#416](https://github.com/dbt-labs/dbt-utils/pull/416))

# dbt-utils v0.7.2

## Features

- Add `not_null_proportion` generic test that allows the user to specify the minimum (`at_least`) tolerated proportion (e.g., `0.95`) of non-null values ([#411](https://github.com/dbt-labs/dbt-utils/pull/411))


## Under the hood
- Allow user to provide any case type when defining the `exclude` argument in `dbt_utils.star()` ([#403](https://github.com/dbt-labs/dbt-utils/pull/403))
- Log whole row instead of just column name in 'accepted_range' generic test to allow better visibility into failures ([#413](https://github.com/dbt-labs/dbt-utils/pull/413))
- Use column name to group in 'get_column_values ' to allow better cross db functionality ([#407](https://github.com/dbt-labs/dbt-utils/pull/407))

# dbt-utils v0.7.1

## Under the hood

- Declare compatibility with dbt v0.21.0, which has no breaking changes for this package ([#398](https://github.com/dbt-labs/dbt-utils/pull/398))


# dbt-utils v0.7.0
## Breaking changes

### 🚨 New dbt version

dbt v0.20.0 or greater is required for this release. If you are not ready to upgrade, consider using a previous release of this package.

In accordance with the version upgrade, this package release includes breaking changes to:
- Generic (schema) tests
- `dispatch` functionality

### 🚨 get_column_values
The order of (optional) arguments has changed in the `get_column_values` macro.

Before:
```jinja
{% macro get_column_values(table, column, order_by='count(*) desc', max_records=none, default=none) -%}
...
{% endmacro %}
```

After:
```jinja
{% macro get_column_values(table, column, max_records=none, default=none) -%}
...
{% endmacro %}
```
If you were relying on the position to match up your optional arguments, this may be a breaking change — in general, we recommend that you explicitly declare any optional arguments (if not all of your arguments!)
```
-- before: This works on previous version of dbt-utils, but on 0.7.0, the `50` would be passed through as the `order_by` argument
{% set payment_methods = dbt_utils.get_column_values(
        ref('stg_payments'),
        'payment_method',
        50
) %}

-- after
{% set payment_methods = dbt_utils.get_column_values(
        ref('stg_payments'),
        'payment_method',
        max_records=50
) %}
```

## Features
* Add new argument, `order_by`, to `get_column_values` (code originally in [#289](https://github.com/dbt-labs/dbt-utils/pull/289/) from [@clausherther](https://github.com/clausherther), merged via [#349](https://github.com/dbt-labs/dbt-utils/pull/349/))
* Add `slugify` macro, and use it in the pivot macro. :rotating_light: This macro uses the `re` module, which is only available in dbt v0.19.0+. As a result, this feature introduces a breaking change. ([#314](https://github.com/dbt-labs/dbt-utils/pull/314))
* Add `not_null_proportion` generic test that allows the user to specify the minimum (`at_least`) tolerated proportion (e.g., `0.95`) of non-null values

## Under the hood
* Update the default implementation of concat macro to use `||` operator ([#373](https://github.com/dbt-labs/dbt-utils/pull/314) from [@ChristopheDuong](https://github.com/ChristopheDuong)). Note this may be a breaking change for adapters that support `concat()` but not `||`, such as Apache Spark.
- Use `power()` instead of `pow()` in `generate_series()` and `haversine_distance()` as they are synonyms in most SQL dialects, but some dialects only have `power()` ([#354](https://github.com/dbt-labs/dbt-utils/pull/354) from [@swanderz](https://github.com/swanderz))
- Make `get_column_values` return the default value passed as a parameter instead of an empty string before compilation ([#304](https://github.com/dbt-labs/dbt-utils/pull/386) from [@jmriego](https://github.com/jmriego)

# dbt-utils v0.6.6

## Fixes

- make `sequential_values` generic test use `dbt_utils.type_timestamp()` to allow for compatibility with db's without timestamp data type. [#376](https://github.com/dbt-labs/dbt-utils/pull/376) from [@swanderz](https://github.com/swanderz)

# dbt-utils v0.6.5
## Features
* Add new `accepted_range` test ([#276](https://github.com/dbt-labs/dbt-utils/pull/276) [@joellabes](https://github.com/joellabes))
* Make `expression_is_true` work as a column test (code originally in [#226](https://github.com/dbt-labs/dbt-utils/pull/226/) from [@elliottohara](https://github.com/elliottohara), merged via [#313](https://github.com/dbt-labs/dbt-utils/pull/313/))
* Add new generic test, `not_accepted_values` ([#284](https://github.com/dbt-labs/dbt-utils/pull/284) [@JavierMonton](https://github.com/JavierMonton))
* Support a new argument, `zero_length_range_allowed` in the `mutually_exclusive_ranges` test ([#307](https://github.com/dbt-labs/dbt-utils/pull/307) [@zemekeneng](https://github.com/zemekeneng))
* Add new generic test, `sequential_values` ([#318](https://github.com/dbt-labs/dbt-utils/pull/318), inspired by [@hundredwatt](https://github.com/hundredwatt))
* Support `quarter` in the `postgres__last_day` macro ([#333](https://github.com/dbt-labs/dbt-utils/pull/333/files) [@seunghanhong](https://github.com/seunghanhong))
* Add new argument, `unit`, to `haversine_distance` ([#340](https://github.com/dbt-labs/dbt-utils/pull/340) [@bastienboutonnet](https://github.com/bastienboutonnet))
* Add new generic test, `fewer_rows_than` (code originally in [#221](https://github.com/dbt-labs/dbt-utils/pull/230/) from [@dmarts](https://github.com/dmarts), merged via [#343](https://github.com/dbt-labs/dbt-utils/pull/343/))

## Fixes
* Handle booleans gracefully in the unpivot macro ([#305](https://github.com/dbt-labs/dbt-utils/pull/305) [@avishalom](https://github.com/avishalom))
* Fix a bug in `get_relation_by_prefix` that happens with Snowflake external tables. Now the macro will retrieve tables that match the prefix which are external tables ([#351](https://github.com/dbt-labs/dbt-utils/pull/351))
* Fix `cardinality_equality` test when the two tables' column names differed ([#334](https://github.com/dbt-labs/dbt-utils/pull/334) [@joellabes](https://github.com/joellabes))

## Under the hood
* Fix Markdown formatting for hub rendering ([#336](https://github.com/dbt-labs/dbt-utils/issues/350) [@coapacetic](https://github.com/coapacetic))
* Reorder readme and improve docs

# dbt-utils v0.6.4

### Fixes
- Fix `insert_by_period` to support `dbt v0.19.0`, with backwards compatibility for earlier versions ([#319](https://github.com/dbt-labs/dbt-utils/pull/319), [#320](https://github.com/dbt-labs/dbt-utils/pull/320))

### Under the hood
- Speed up CI via threads, workflows ([#315](https://github.com/dbt-labs/dbt-utils/pull/315), [#316](https://github.com/dbt-labs/dbt-utils/pull/316))
- Fix `equality` test when used with ephemeral models + explicit column set ([#321](https://github.com/dbt-labs/dbt-utils/pull/321))
- Fix `get_query_results_as_dict` integration test with consistent ordering ([#322](https://github.com/dbt-labs/dbt-utils/pull/322))
- All macros are now properly dispatched, making it possible for non-core adapters to implement a shim package for dbt-utils ([#312](https://github.com/dbt-labs/dbt-utils/pull/312)) Thanks [@chaerinlee1](https://github.com/chaerinlee1) and [@swanderz](https://github.com/swanderz)
- Small, non-breaking changes to accomodate TSQL (can't group by column number references, no real TRUE/FALSE values, aggregation CTEs need named columns) ([#310](https://github.com/dbt-labs/dbt-utils/pull/310)) Thanks [@swanderz](https://github.com/swanderz)
- Make `get_relations_by_pattern` and `get_relations_by_prefix` more powerful by returning `relation.type` ([#323](https://github.com/dbt-labs/dbt-utils/pull/323))

# dbt-utils v0.6.3

- Bump `require-dbt-version` to `[">=0.18.0", "<0.20.0"]` to support dbt v0.19.0 ([#308](https://github.com/dbt-labs/dbt-utils/pull/308), [#309](https://github.com/dbt-labs/dbt-utils/pull/309))

# dbt-utils v0.6.2

## Fixes
- Fix the logic in `get_tables_by_pattern_sql` to ensure non-default arguments are respected ([#279](https://github.com/dbt-labs/dbt-utils/pull/279))


# dbt-utils v0.6.1

## Fixes
- Fix the logic in `get_tables_by_pattern_sql` for matching a schema pattern on BigQuery ([#275](https://github.com/dbt-labs/dbt-utils/pull/275/))

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
specific to their database ([#267](https://github.com/dbt-labs/dbt-utils/pull/267))
* Use `add_ephemeral_prefix` instead of hard-coding a string literal, to support
database adapters that use different prefixes ([#267](https://github.com/dbt-labs/dbt-utils/pull/267))
* Implement a quote_columns argument in the unique_combination_of_columns generic test ([#270](https://github.com/dbt-labs/dbt-utils/pull/270) [@JoshuaHuntley](https://github.com/JoshuaHuntley))

## Quality of life
* Remove deprecated macros `get_tables_by_prefix` and `union_tables` ([#268](https://github.com/dbt-labs/dbt-utils/pull/268))
* Remove `get_tables_by_pattern` macro, which is equivalent to the `get_tables_by_pattern_sql` macro (the latter has a more logical name) ([#268](https://github.com/dbt-labs/dbt-utils/pull/268))

# dbt-utils v0.5.1

## Quality of life
* Improve release process, and fix tests ([#251](https://github.com/dbt-labs/dbt-utils/pull/251))
* Make deprecation warnings more useful ([#258](https://github.com/dbt-labs/dbt-utils/pull/258) [@tayloramurphy](https://github.com/tayloramurphy))
* Add more docs for `date_spine` ([#265](https://github.com/dbt-labs/dbt-utils/pull/265) [@calvingiles](https://github.com/calvingiles))
