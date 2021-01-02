.DEFAULT_GOAL:=help

.EXPORT_ALL_VARIABLES:

ifndef VERBOSE
.SILENT:
endif

# set default shell
SHELL=/bin/bash -o pipefail -o errexit

# Use the 0.0 tag for testing, it shouldn't clobber any release builds
TAG ?= $(shell cat TAG)

REPO_INFO ?= $(shell git config --get remote.origin.url)
COMMIT_SHA ?= git-$(shell git rev-parse --short HEAD)

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: image
image:
	@docker build -t foobarqix:$(TAG) images/runtime

.PHONY: base-env-image
base-env-image: 
	@docker build images/base-env -t base-env

.PHONY: clean-image
clean-image:
	echo "removing old image foobarqix:$(TAG)"
	@docker rmi -f foobarqix:$(TAG) || true

.PHONY: build
build:  base-env-image
	@BASE_IMAGE=base-env \
       	build/run-in-docker.sh \
		build/build.sh

.PHONY: clean
clean: ## Remove .cache directory
	rm -rf .cache/

.PHONY: dev-env
dev-env: image ## Starts a local Kubernetes cluster using minikube, builds and deploys application
	@build/dev-env.sh

.PHONY: show-version
show-version:
	echo -n $(TAG)

