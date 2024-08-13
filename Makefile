DC = docker compose

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

### App cluster
.PHONY: cluster-create cluster-delete cluster-list cluster-info
cluster-create: ## Create dev-cluster
	@echo "Init cluster: dev-cluster"
	k3d cluster create --config kubernetes/cluster.yaml

cluster-delete: ## Delete dev-cluster
	@echo "Delete cluster: dev-cluster"
	k3d cluster delete dev-cluster

cluster-list: ## List dev-clusters
	k3d cluster list

cluster-info: ## Check dev-cluster
	@echo "Check cluster: dev-cluster"
	@echo "------------------------------"
	kubectl get pods,ingress,services --output wide

### Apps
app-docker-registry-ui-deploy:
	kubectl apply -f deployments/docker-registry-ui.yaml

app-docker-registry-ui-delete:
	kubectl delete -f deployments/docker-registry-ui.yaml
