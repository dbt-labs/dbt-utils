#!/bin/bash
VENV="venv/bin/activate"

if [[ ! -f $VENV ]]; then
    python3 -m venv venv
    . $VENV

    pip install --upgrade pip setuptools
    pip install -r dev-requirements.txt
    pip install --pre "dbt-$1"
fi

. $VENV
python3 -m pytest tests/functional --profile $1
