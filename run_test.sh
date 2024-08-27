#!/bin/bash

# Show location of local install of dbt
echo $(which dbt)

# Show version and installed adapters
dbt --version

# Set the profile
cd integration_tests
export DBT_PROFILES_DIR=.

# Show the location of the profiles directory and test the connection
dbt debug --target $1

dbt deps --target $1 || exit 1
dbt build --target $1 --full-refresh || exit 1
