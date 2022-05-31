#!/bin/bash

<<<<<<< HEAD
python3 -m pytest tests/functional --profile $1
=======
if [[ ! -f $VENV ]]; then
    python3 -m venv venv
    . $VENV

    pip install --upgrade pip setuptools
    pip install --pre "dbt-$1" -r dev-requirements.txt
fi

. $VENV
python3 -m pytest tests/functional -n4 --profile $1
>>>>>>> 9a245dc (Experiment with adding functional tests)
