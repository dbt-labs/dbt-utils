# dbt-utils releases

## When do we release?
There's a few scenarios that might prompt a release:

| Scenario                                   | Release type |
|--------------------------------------------|--------------|
| Breaking changes to existing macros        | major        |
| New functionality                          | minor        |
| Fixes to existing macros                   | patch        |

## Release process

1. Begin a new release by clicking [here](https://github.com/dbt-labs/dbt-utils/releases/new)
1. Click "Choose a tag", then paste your version number (with no "v" in the name), then click "Create new tag: x.y.z. on publish"
    - The “Release title” will be identical to the tag name
1. Click the "Generate release notes" button
1. Copy and paste the generated release notes into [`CHANGELOG.md`](https://github.com/dbt-labs/dbt-utils/blob/main/CHANGELOG.md?plain=1), reformat to match previous entries, commit, and merge into the `main` branch ([example](https://github.com/dbt-labs/dbt-utils/pull/901))
1. Click the "Publish release" button
    - This will automatically create an "Assets" section containing:
        - Source code (zip)
        - Source code (tar.gz)

## Post-release

1. Delete the automatic Zapier post ([example of one intentionally not deleted](https://getdbt.slack.com/archives/CU4MRJ7QB/p1646272037304639)) and replace it with a custom post in the `#package-ecosystem` channel in “The Community Slack” using the content from the tagged release notes (but replace GitHub handles with Slack handles) ([example](https://getdbt.slack.com/archives/CU4MRJ7QB/p1649372590957309))
