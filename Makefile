DC = docker compose

.DEFAULT_GOAL = help

%:
	@echo "unknown target '$@'"

### INFO
.PHONY: help
help: ## Help
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' Makefile | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

### DO THIS FIRST
.PHONY: stuff-install
stuff-install: ## Install needed stuff
	@sudo ./stuff-install.sh

### Cluster
.PHONY: up
up: ## Create dev-cluster
	@echo "Init cluster: dev-cluster"
	k3d cluster create --config cluster.yaml
	kubectl apply -f deployments/docker-registry-ui.yaml

.PHONY: down
down: ## Delete dev-cluster
	@echo "Delete cluster: dev-cluster"
	# kubectl delete -f deployments/docker-registry-ui.yaml
	k3d cluster delete --config cluster.yaml

.PHONY: tools-up
tools-up:
	kubectl apply -f deployments/postgres.yaml
	kubectl apply -f deployments/kafka.yaml
	kubectl apply -f deployments/kafka-ui.yaml
	kubectl apply -f deployments/rabbitmq.yaml

.PHONY: tools-down
tools-down:
	kubectl delete -f deployments/rabbitmq.yaml
	kubectl delete -f deployments/kafka-ui.yaml
	kubectl delete -f deployments/kafka.yaml
	kubectl delete -f deployments/postgres.yaml
	
### Some tools
cluster-list: ## List dev-clusters
	k3d cluster list

cluster-info: ## Check dev-cluster
	@echo "Check cluster: dev-cluster"
	@echo "------------------------------"
	kubectl get pods,ingress,services --output wide

