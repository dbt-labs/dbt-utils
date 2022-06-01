#!/bin/bash

if [[ ! -f $VENV ]]; then
    python3 -m venv venv
    . $VENV

    python3 -m pip install --upgrade pip setuptools
    python3 -m pip install --pre "dbt-$1" -r dev-requirements.txt
fi

. $VENV
python3 -m pytest tests/functional -n4 --profile $1
