#!/bin/bash

if [ -n "$DEBUG" ]; then
  set -x
fi

set -o errexit
set -o nounset
set -o pipefail

DOCKER_OPTS=${DOCKER_OPTS:-}

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd -P)"

BASE_IMAGE=${BASE_IMAGE:-}
FLAGS=$*

mkdir -p "${REPO_ROOT}/.cache"

docker run                                            \
  --tty                                               \
  --rm                                                \
  ${DOCKER_OPTS}                                      \
  -e "HOME=/tmp"                                      \
  -e "XDG_CACHE_HOME=/tmp/.cache"                     \
  -v "${REPO_ROOT}/.cache:/.cache"                    \
  -v "${REPO_ROOT}/.cache:/tmp/.cache"                \
  -v "${REPO_ROOT}:${REPO_ROOT}"                      \
  -u "$(id -u "${USER}"):$(id -g "${USER}")"          \
  -w "${REPO_ROOT}"                                   \
  "${BASE_IMAGE}" /bin/bash -c "${FLAGS}"


