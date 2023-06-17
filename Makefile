.PHONY: help build run debug clean
.DEFAULT_GOAL := help

SHELL := /bin/bash

# Makefile directory
MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

# Local Docker image tag
DOCKER_TAG := ninokin/mikanos:test

# Local web server port
DOCKER_PORT := 8090

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

debug: ## Debug to check environment variables
	@source $(HOME)/osbook/devenv/buildenv.sh; \
	 echo "CPPFLAGS: $$CPPFLAGS"; \
	 echo "LDFLAGS: $$LDFLAGS"

clean: ## Clean up the site image and generated documentation
	@echo -e "[INFO] Delete artifacts..."
	@git ls-files --others --ignored --exclude-standard | grep -E "^(apps|kernel)" | xargs -I{} rm {}
	@rm *.img
	@echo -e "[INFO] Deleting artifacts was successfully!"
