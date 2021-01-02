#!/bin/bash

if [ -n "$DEBUG" ]; then
	set -x
fi

set -o errexit
set -o nounset
set -o pipefail

cd src
mkdir "${XDG_CACHE_HOME}/test-config" 2> /dev/null || true
export XDG_CONFIG_HOME="${XDG_CACHE_HOME}/test-config"
/opt/poetry/bin/poetry config virtualenvs.path "${XDG_CACHE_HOME}/test-virtualenv"
/opt/poetry/bin/poetry install
/opt/poetry/bin/poetry run ./scripts/test
