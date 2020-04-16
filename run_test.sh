#!/bin/bash
VENV="venv/bin/activate"

if [[ ! -f $VENV ]]; then
    python3 -m venv venv
    . $VENV

    pip install --upgrade pip setuptools
    pip install dbt
fi

. $VENV
cd integration_tests

mkdir -p ~/.dbt
cp ci/sample.profiles.yml ~/.dbt/profiles.yml

dbt deps --target $1
dbt seed --target $1 --full-refresh
dbt run --target $1
dbt test --target $1