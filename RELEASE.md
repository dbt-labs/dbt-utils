# dbt-utils releases

TODO - update the following content since it is not up-to-date.

## When do we release?
There's a few scenarios that might prompt a release:

| Scenario                                   | Release type |
|--------------------------------------------|--------------|
| New functionality¹                         | minor        |
| Breaking changes to existing macros        | minor        |
| Fixes to existing macros                   | patch        |
| dbt minor release with no breaking changes | patch        |
| dbt minor release with breaking changes    | minor        |

¹New macros were previously considered patch releases — we have brought them up to minor releases to make versioning for dependencies clearer.

## Branching strategy

At any point, there should be two long-lived branches:
- `main` (default): This reflects the most recent release of dbt-utils
- `dev/0.x.0`: This reflects the next minor release, where `x` will be replaced with the minor version number

The `dev/0.x.0` branch should be merged into `main` branch when new releases are created.

## Process for minor releases
e.g. for releasing `0.x.0`
1. Create the PR to merge `dev/0.x.0` into `main`. Also update the `CHANGELOG` as part of this PR, and merge it.
2. Create the GitHub release from the `main` branch.
3. Delete the `dev/0.x.0` branch, and create a new branch `dev/0.x+1.0` from `main`, adding branch protection to it.
4. [Create a new issue](https://github.com/dbt-labs/dbt-utils/issues/new/choose) from the "dbt-utils Minor Release Follow-Up" template to also update any dependencies.

## Process for patch releases
1. Create the release.
2. Then rebase the current `dev/0.x.0` branch on top of the `main` branch so that any fixes will be included in the next minor release.

No dependent packages need to be updated for patch releases (e.g. codegen, audit-helper)
