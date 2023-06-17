.PHONY: help build run debug clean mkdocs-build mkdocs-serve
.DEFAULT_GOAL := help

SHELL := /bin/bash

# Makefile directory
MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# Local Docker image tag
DOCKER_TAG := ninokin/mikanos:test

# Local web server port
DOCKER_PORT := 8090

# Local Docker container name
DOCKER_CONTAINER := test-server

# Home directory
HOME := $(shell echo $(HOME))

# Current working directory
PWD := $(shell pwd)

# User ID for the current user
UID := $(shell id -u)

# Group ID for the current user
GID := $(shell id -g)

# Temporary directory
TEST_DIR := $(shell mktemp --directory --tmpdir craft.XXXXXXXXXX)

export DOCKER_BUILDKIT=1

# To create a disk image that includes a group of apps in the apps directory and resources such as fonts, specify the APPS_DIR and RESOURCE_DIR variables.
export APPS_DIR=apps
export RESOURCE_DIR=resource

# For more information on this technique, see
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html

help: ## Show this help message
	@echo -e "\nUsage: make TARGET\n\nTargets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

build: ## Build Mikan OS
	@echo -e "[INFO] Setup environment variables..."; \
	 source $(HOME)/osbook/devenv/buildenv.sh; \
	 echo -e "[INFO] Build Mikan OS..."; \
	 source $(MAKEFILE_DIR)/build.sh && echo -e "[INFO] Build was successfully!"

run: ## Run Mikan OS on QEMU
	@echo -e "[INFO] Setup environment variables..."; \
	 source $(HOME)/osbook/devenv/buildenv.sh; \
	 echo -e "[INFO] Run Mikan OS on QEMU..."; \
	 source $(MAKEFILE_DIR)/build.sh run && echo -e "[INFO] Build was successfully!"

clean: ## Clean up the site image and generated documentation
	@echo -e "[INFO] Removing artifacts..."
	@git ls-files --others --ignored --exclude-standard | grep -E "^(apps|kernel)" | xargs -I{} rm {}
	@[ -z "$$(find . -maxdepth 1 -type f -name '*.img')" ] || rm *.img
	@[ -z "$$(docker images --quiet $(DOCKER_TAG))" ] || docker image rm $(DOCKER_TAG)
	@[ -z "$$(find . -maxdepth 1 -type d -name 'site')" ] || sudo chmod -R 777 site/ && rm -rf site/
	@echo -e "[INFO] Removing artifacts was successfully!"

#---------------------------------------#
# MkDocs                                #
#---------------------------------------#
mkdocs-build: ## Build documentation for MkDocs
	@docker run --rm -it -v $(PWD):/docs squidfunk/mkdocs-material build

mkdocs-serve: ## Serve documentation for MkDocs
	@docker run --rm -it -p 8000:8000 -v $(PWD):/docs squidfunk/mkdocs-material

#---------------------------------------#
# pre-commit                            #
#---------------------------------------#
# FIXME: The following option is not available. If you use them, please fix before using.
pre-commit: docker ## pre-commit (NOT available)
	@docker run --rm -v $(PWD):/app $(DOCKER_TAG)

debug: docker ## Debug to check environment variables (NOT available)
	@docker run --name $(DOCKER_CONTAINER) -v $(PWD):/app -it -d $(DOCKER_TAG)
	@docker exec -it $(DOCKER_CONTAINER) bash

stop: ## kill Docker container
	@docker kill $(DOCKER_CONTAINER)

docker: ## Build the Docker image
	@echo -e "[INFO] Building the Docker image..."
	@docker build -t $(DOCKER_TAG) .
	@echo -e "[INFO] Building the Docker image is successfully!"
