#!/bin/bash

# Show location of local install of dbt
echo $(which dbt)

# Show version and installed adapters
dbt --version

cd integration_tests
cp ci/sample.profiles.yml profiles.yml
export DBT_PROFILES_DIR=.

# Show location of profiles directory and test a connection
dbt debug

_models=""
_seeds="--full-refresh"
if [[ ! -z $2 ]]; then _models="--models $2"; fi
if [[ ! -z $3 ]]; then _seeds="--select $3 --full-refresh"; fi

dbt deps --target $1 || exit 1
dbt seed --target $1 $_seeds || exit 1
if [ $1 == 'redshift' ]; then
    dbt run -x -m test_insert_by_period --full-refresh --target redshift || exit 1
fi
dbt run -x --target $1 $_models || exit 1
dbt test -x --target $1 $_models || exit 1
