---
status: accepted
date: 2022-03-01
deciders: Joel Labes and Jeremy Cohen
consulted: dbt community
informed: dbt community
---
# The future of `dbt_utils` - break it into more logical chunks

## Context and Problem Statement

`dbt_utils` is the most-used package in the [dbt Hub]() by a wide margin and it is installed in 1/3 of weekly active projects (as-of early 2022). The functionality with this package can be categorized into different use cases (each having their own rate of iteration):
- Cross-database macros serve as a foundation to enable compatibility in other packages
- Macros to abstract away complex work
- Useful tests which aren't built into dbt Core
- A catchall for experiments

The `dbt_utils` package is doing a lot, and it could be split up into more logical chunks. If we pull out each category into a stand-alone package, they can each do their own thing without interfering with one another.

How would this affect users, package maintainers, and adapter maintainers?

## Considered Options

For each category of functionality, there are four main options for its future home:
* stay in `dbt_utils`
* move to its own stand-alone package or another existing repository (e.g. [dbt-expectations](https://github.com/calogica/dbt-expectations) in the case of tests, and [dbt-labs-experimental-features](https://github.com/dbt-labs/dbt-labs-experimental-features) in the case of experiments)
* move to definition in Core, implementation in adapters
* complete abandonment / deprecation

Since there are four categories and 4 possibilities for destinations, that gives 4^4 = 256 unique options. Rather than enumerate all of them, we'll restrict discussion to a shorter list:

* Migrate cross-db functions from `dbt_utils` to definition in Core, implementation in adapters
* Split `dbt_utils` into multiple stand-alone packages
* Keep `dbt_utils` as-is

## Decision Outcome

Chosen option: "Migrate cross-db functions from `dbt_utils` to definition in Core, implementation in adapters", because
that was the consensus that emerged from the discussion in [dbt-utils #487](https://github.com/dbt-labs/dbt-utils/discussions/487).

Passthroughs will be left behind for migrated macros (so that calls to `dbt_utils.hash` don't suddenly start failing). New cross-database macros can be added in minor and major releases for dbt Core (but not patch releases). End users will retain the ability to use `dispatch` to shim/extend packages to adapters that don't yet support a particular macro.

Additional decisions:
- Keep tests and non-cross-database macros together in `dbt_utils`
- Move experiments to a separate repo (i.e., the `load_by_period` macro)

## Validation

Each moved macro will be validated by leaving a definition in `dbt_utils` and dispatching it to `dbt-core`. Independent continuous integration (CI) testing will exist within `dbt-core`, adapters, and `dbt_utils` using the [new pytest framework](https://docs.getdbt.com/docs/contributing/testing-a-new-adapter).

## Pros and Cons of the Options

### Definition in Core, implementation in adapters

* Good, because common, reusable functionality that differs across databases will work "out of the box"
* Good, because functionality can subjected to more [rigorous testing](https://docs.getdbt.com/docs/contributing/testing-a-new-adapter)
* Good, because we hope that many package vendors could drop their dependencies on `dbt_utils` altogether, which makes version resolution easier
* Good, because it's more convenient to reference the macro as `dateadd` instead of `dbt_utils.dateadd` (and `dbt.dateadd` is preserved as an option for those that appreciate an explicit namespace)
* Good, because overriding global macros is more simple than overriding package macros
* Good, because changes to macros are more clearly tied to `dbt-core` versions, rather than needing to worry about breaking changes in the matrix of `dbt-core` + `dbt_utils` minor versions
* Good, because it establishes a precedent and pathway for battle-testing and maturing functionality before being promoted to Core
* Neutral, because new cross-database macros will need to wait for the next minor (or major version) of `dbt-core` -- patch versions aren't an option
    * End users can use `dispatch` or the macro can be added to a release of `dbt_utils` until it is promoted to `dbt-core`
* Bad, because **higher barrier to contribution**
    * to contribute to `dbt_utils` today, you just need to be a fairly skilled user of dbt. Even the integration tests are "just" a dbt project. To contribute to `dbt-core` or adapter plugins, you need to also know enough to set up a local development environment, to feel comfortable writing/updating Pythonic integration tests.
* Bad, because unknown **maturity**
    * adding these macros into `dbt-core` "locks" them in. Changes to any macros may result in uglier code due to our commitment to backwards compatibility (e.g. addition of new arguments)
* Bad, because less **macro discoverability**
    * Arguably, the macros in `dbt-core` are less discoverable than the ones in `dbt_utils`. This can be mitigated somewhat via significant manual effort over at [docs.getdbt.com](https://docs.getdbt.com/)
* Bad, because less opportunity to **teach users about macros/packages**
    * The fact that so many projects install `dbt_utils` feels like a good thing — in the process, users are prompted to learn about packages (an essential dbt feature), explore other available packages, and realize that anything written in `dbt_utils` is something they fully have the power to write themselves, in their own projects. (That's not the case for most code in `dbt-core` + adapter plugins). In particular, users can write their own generic tests. We want to empower users to realize that they can write their own and not feel constrained by what's available out of the box.

### Split `dbt_utils` into multiple stand-alone packages

* Good, because all the tests could be in one package, which would make the purpose of each package more clear and logically separated.
* Bad, because it is easier to install a single package and then discover more functionality within it. It is non-trivial to search the whole hub for more packages which is a higher barrier than looking within a single `dbt_utils` package curated by dbt Labs.

### Keep `dbt_utils` as-is

* Good, because we wouldn't have to do anything.
* Good, because the user only has to install one package and gets a ton of functionality.
* Bad, because it feels like the `dbt_utils` package is trying to do too much.
* Bad, because each category of macros can't target their own users and dictate their own rate of iteration.

## More Information

The initial public discussion is in [dbt-utils #487](https://github.com/dbt-labs/dbt-utils/discussions/487), and [dbt-core #4813](https://github.com/dbt-labs/dbt-core/issues/4813) captures the main story.
