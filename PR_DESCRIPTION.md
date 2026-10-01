Migrate top-level test `values` to `arguments` (dbt0102)

This repo contains a small YAML-only change to the integration tests schema to
wrap `values:` under `arguments:` for `accepted_values` tests.

Rationale:
- Addresses deprecation warnings about top-level test arguments (dbt0102).
- No behavior change to the tests; simply adjusts to the newer expected schema.

See the PR for the exact diff and additional context.
