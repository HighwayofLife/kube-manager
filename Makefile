ifneq (,)
.error This Makefile requires GNU Make.
endif

.DEFAULT_GOAL := run

########################################################################
## Self-Documenting Makefile Help                                     ##
## https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html ##
########################################################################
.PHONY: help
help:
	@ grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build container and generate kubeconfig
	@./scripts/build
	@./script/generate_kubeconfig.sh

.PHONY: run
run: ## Run the kubectl container. Just run `make`
	@./scripts/run

.PHONY: generate
generate: ## Generate the kubeconfig
	@./script/generate_kubeconfig.sh
