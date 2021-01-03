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
image: build ## Build foobarquix image
	@docker build -t foobarquix:$(TAG) images/runtime

.PHONY: base-env-image
base-env-image: 
	@docker build images/base-env -t base-env

.PHONY: clean-image
clean-image: ## Remove foobaquix image
	echo "removing old image foobarquix:$(TAG)"
	@docker rmi -f foobarquix:$(TAG) || true

.PHONY: build
build:  base-env-image ## Build foobarquix binary
	@BASE_IMAGE=base-env \
       	build/run-in-docker.sh \
		build/build.sh

.PHONY: test
test:  base-env-image ## Test foobarquix app
	@BASE_IMAGE=base-env \
       	build/run-in-docker.sh \
		build/lint.sh
	@BASE_IMAGE=base-env \
	build/run-in-docker.sh \
		build/test.sh

.PHONY: clean
clean: ## Remove .cache directory and foobarquix binary
	rm -rf .cache/ image/runtime/bin

.PHONY: dev-env
dev-env: image ## Start a local Kubernetes cluster using minikube and deploy application
	@build/dev-env.sh

.PHONY: show-version
show-version:
	echo -n $(TAG)

