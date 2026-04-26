#!/bin/bash

python3 -m pytest tests/functional -n4 --profile $1
