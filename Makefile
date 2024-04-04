
.DEFAULT_GOAL = help

%:
	# empty target

### INFO
.PHONY: help
help: ## Help
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' Makefile | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

### DO THIS FIRST
.PHONY: stuff-install
stuff-install: ## Install needed stuff
	@cd scripts && sudo ./stuff-install.sh

### K3D shortcuts
.PHONY: cluster-list cluster-create cluster-delete cluster-stop cluster-start
cluster-list: ## k3d cluster list
	@k3d cluster list
cluster-create: ## k3d cluster create
	@k3d cluster create $(filter-out $@,$(MAKECMDGOALS))
cluster-delete: ## k3d cluster delete
	@k3d cluster delete $(filter-out $@,$(MAKECMDGOALS))
cluster-start: ## k3d cluster start
	@k3d cluster start $(filter-out $@,$(MAKECMDGOALS))
cluster-stop: ## k3d cluster stop
	@k3d cluster stop $(filter-out $@,$(MAKECMDGOALS))

