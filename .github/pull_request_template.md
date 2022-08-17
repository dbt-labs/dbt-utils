resolves #

This is a:
- [ ] documentation update
- [ ] bug fix with no breaking changes
- [ ] new functionality
- [ ] a breaking change

All pull requests from community contributors should target the `main` branch (default).

## Description & motivation
<!---
Describe your changes, and why you're making them.
-->

## Checklist
- [ ] This code is associated with an Issue which has been triaged and [accepted for development](https://docs.getdbt.com/docs/contributing/oss-expectations#pull-requests). 
- [ ] I have verified that these changes work locally on the following warehouses (Note: it's okay if you do not have access to all warehouses, this helps us understand what has been covered)
    - [ ] BigQuery
    - [ ] Postgres
    - [ ] Redshift
    - [ ] Snowflake
- [ ] I followed guidelines to ensure that my changes will work on "non-core" adapters by:
    - [ ] dispatching any new macro(s) so non-core adapters can also use them (e.g. [the `star()` source](https://github.com/dbt-labs/dbt-utils/blob/main/macros/sql/star.sql))
    - [ ] using the `limit_zero()` macro in place of the literal string: `limit 0`
    - [ ] using `dbt.type_*` macros instead of explicit datatypes (e.g. `dbt.type_timestamp()` instead of `TIMESTAMP`
- [ ] I have updated the README.md (if applicable)
- [ ] I have added tests & descriptions to my models (and macros if applicable)
- [ ] I have added an entry to CHANGELOG.md
