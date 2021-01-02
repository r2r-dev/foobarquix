#!/bin/bash

if [ -n "$DEBUG" ]; then
	set -x
fi

set -o errexit
set -o nounset
set -o pipefail

cd src
mkdir "${XDG_CACHE_HOME}/build-config" 2> /dev/null || true
export XDG_CONFIG_HOME="${XDG_CACHE_HOME}/build-config"
/opt/poetry/bin/poetry config virtualenvs.create false
/opt/poetry/bin/poetry install --no-dev
python3 -m nuitka \
   --include-package=gunicorn \
   --include-package=uvicorn  \
   --include-package=uvloop \
   --include-package=httptools \
   --include-package=click \
   --include-plugin-directory=app \
   --prefer-source-code \
   --plugin-enable=pylint-warnings \
   --enable-plugin="implicit-imports" \
   --standalone \
   --follow-imports \
   --recurse-all \
   --show-modules \
   --output-dir=../images/runtime/bin \
   wsgi.py

