# dbt-utils v0.6.0 (unreleased)

## Fixes

## Features

* Switch usage of `adapter_macro` to `adapter.dispatch`, and define `dbt_utils_dispatch_list`,
enabling users of community-supported database plugins to add or override macro implementations
specific to their database (#267)
* Use `add_ephemeral_prefix` instead of hard-coding a string literal, to support
database adapters that use different prefixes (#267)

## Quality of life

# dbt-utils v0.5.1

## Fixes

## Features

## Quality of life
* Improve release process, and fix tests (#251)
* Make deprecation warnings more useful (#258 @tayloramurphy)
