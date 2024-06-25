# Contributing to `dbt-utils`

`dbt-utils` is open source software. It is what it is today because community members have opened issues, provided feedback, and [contributed to the knowledge loop](https://www.getdbt.com/dbt-labs/values/). Whether you are a seasoned open source contributor or a first-time committer, we welcome and encourage you to contribute code, documentation, ideas, or problem statements to this project.

Remember: all PRs (apart from cosmetic fixes like typos) should be [associated with an issue](https://docs.getdbt.com/docs/contributing/oss-expectations#pull-requests).

1. [About this document](#about-this-document)
1. [Getting the code](#getting-the-code)
1. [Setting up an environment](#setting-up-an-environment)
1. [Implementation guidelines](#implementation-guidelines)
1. [Testing dbt-utils](#testing)
1. [Adding CHANGELOG Entry](#adding-changelog-entry)
1. [Submitting a Pull Request](#submitting-a-pull-request)

Enable greater collaboration by selecting ["Allow edits from maintainers"](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/allowing-changes-to-a-pull-request-branch-created-from-a-fork#enabling-repository-maintainer-permissions-on-existing-pull-requests) which will allow commits on your PR branch.

## About this document

There are many ways to contribute to the ongoing development of `dbt-utils`, such as by participating in discussions and issues. We encourage you to first read our higher-level document: ["Expectations for Open Source Contributors"](https://docs.getdbt.com/docs/contributing/oss-expectations).

The rest of this document serves as a more granular guide for contributing code changes to `dbt-utils` (this repository). It is not intended as a guide for using `dbt-utils`, and some pieces assume a level of familiarity with Python development (virtualenvs, `pip`, etc). Specific code snippets in this guide assume you are using macOS or Linux and are comfortable with the command line.

### Notes

- **CLA:** Please note that anyone contributing code to `dbt-utils` must sign the [Contributor License Agreement](https://docs.getdbt.com/docs/contributor-license-agreements). If you are unable to sign the CLA, the `dbt-utils` maintainers will unfortunately be unable to merge any of your Pull Requests. We welcome you to participate in discussions, open issues, and comment on existing ones.
- **Branches:** All pull requests from community contributors should target the `main` branch (default). If the change is needed as a patch for a version of `dbt-utils` that has already been released (or is already a release candidate), a maintainer will backport the changes in your PR to the relevant branch.

## Getting the code

### Installing git

You will need `git` in order to download and modify the `dbt-utils` source code. On macOS, the best way to download git is to just install [Xcode](https://developer.apple.com/support/xcode/).

### External contributors

If you are not a member of the `dbt-labs` GitHub organization, you can contribute to `dbt-utils` by forking the `dbt-utils` repository. For a detailed overview on forking, check out the [GitHub docs on forking](https://help.github.com/en/articles/fork-a-repo). In short, you will need to:

1. Fork the `dbt-utils` repository
2. Clone your fork locally
3. Check out a new branch for your proposed changes
4. Push changes to your fork
5. Open a pull request against `dbt-labs/dbt-utils` from your forked repository

### dbt Labs contributors

If you are a member of the `dbt-labs` GitHub organization, you will have push access to the `dbt-utils` repo. Rather than forking `dbt-utils` to make your changes, just clone the repository, check out a new branch, and push directly to that branch.

## Setting up an environment

There are some tools that will be helpful to you in developing locally. While this is the list relevant for `dbt-utils` development, many of these tools are used commonly across open-source python projects.

### Tools

These are the tools used in `dbt-utils` development and testing:
- [`make`](https://users.cs.duke.edu/~ola/courses/programming/Makefiles/Makefiles.html) to run multiple setup or test steps in combination. Don't worry too much, nobody _really_ understands how `make` works, and our Makefile aims to be super simple.
- [CircleCI](https://circleci.com/) for automating tests and checks, once a PR is pushed to the `dbt-utils` repository

A deep understanding of these tools in not required to effectively contribute to `dbt-utils`, but we recommend checking out the attached documentation if you're interested in learning more about each one.

## Implementation guidelines

Ensure that changes will work on "non-core" adapters by:
- dispatching any new macro(s) so non-core adapters can also use them (e.g. [the `star()` source](https://github.com/dbt-labs/dbt-utils/blob/main/macros/sql/star.sql))
- using the `limit_zero()` macro in place of the literal string: `limit 0`
- using [`type_*` macros](https://docs.getdbt.com/reference/dbt-jinja-functions/cross-database-macros#data-type-functions) instead of explicit datatypes (e.g. [`type_timestamp()`](https://docs.getdbt.com/reference/dbt-jinja-functions/cross-database-macros#type_timestamp) instead of `TIMESTAMP`

## Testing

Once you're able to manually test that your code change is working as expected, it's important to run existing automated tests, as well as adding some new ones. These tests will ensure that:
- Your code changes do not unexpectedly break other established functionality
- Your code changes can handle all known edge cases
- The functionality you're adding will _keep_ working in the future

See here for details for running existing integration tests and adding new ones:
- [integration_tests/README.md](integration_tests/README.md)

## Adding CHANGELOG Entry

We use [automatically generated release notes](https://docs.github.com/en/repositories/releasing-projects-on-github/automatically-generated-release-notes) to generate `CHANGELOG` entries. **Note:** Do not edit the `CHANGELOG.md` directly. Your modifications will be lost.

You don't need to worry about which `dbt-utils` version your change will go into. Just create the changelog entry at the top of CHANGELOG.md and open your PR against the `main` branch. All merged changes will be included in the next minor version of `dbt-utils`. The maintainers _may_ choose to "backport" specific changes in order to patch older minor versions. In that case, a maintainer will take care of that backport after merging your PR, before releasing the new version of `dbt-utils`.

## Submitting a Pull Request

A `dbt-utils` maintainer will review your PR. They may suggest code revision for style or clarity, or request that you add unit or integration test(s). These are good things! We believe that, with a little bit of help, anyone can contribute high-quality code.

Automated tests run via CircleCI. If you're a first-time contributor, all tests (including code checks and unit tests) will require a maintainer to approve. Changes in the `dbt-utils` repository trigger integration tests.

Once all tests are passing and your PR has been approved, a `dbt-utils` maintainer will merge your changes into the active development branch. And that's it! Happy developing :tada:
