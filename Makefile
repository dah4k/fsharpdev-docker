# Copyright 2024 dah4k
# SPDX-License-Identifier: EPL-2.0

DOCKER      ?= docker
TAG         ?= local/fsharpdev
_ANSI_NORM  := \033[0m
_ANSI_CYAN  := \033[36m

.PHONY: up
up: $(TAG) ## Start container image
	$(DOCKER) run --interactive --tty --rm $(TAG)

.PHONY: $(TAG)
$(TAG): Dockerfile
	$(DOCKER) build --tag $(TAG) --file Dockerfile .

.PHONY: destroy
destroy: ## Destroy container image
	$(DOCKER) image remove --force $(TAG)

.PHONY: distclean
distclean: ## Prune all container images
	$(DOCKER) image prune --force
	$(DOCKER) system prune --force

.PHONY: help usage
help usage:
	@grep -hE '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##"}; {printf "$(_ANSI_CYAN)%-20s$(_ANSI_NORM) %s\n", $$1, $$2}'
