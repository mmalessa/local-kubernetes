DC = docker compose
K3D_CLUSTER_NAME = "dev-cluster"
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
	@echo "Init cluster: $(K3D_CLUSTER_NAME)"
	k3d cluster create --config cluster.yaml
	kubectl apply -f deployments/docker-registry-ui.yaml

.PHONY: down
down: ## Delete dev-cluster
	@echo "Delete cluster: $(K3D_CLUSTER_NAME)"
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
	@echo "Check cluster: $(K3D_CLUSTER_NAME)"
	@echo "------------------------------"
	kubectl get pods,ingress,services --output wide

k3d-import-image:
	@if [ -z "$(IMAGE)" ]; then \
		echo "Please specify the image name using IMAGE=<name>"; \
		exit 1; \
	fi
	@echo "Importing image '$(IMAGE)' into k3d cluster '$(K3D_CLUSTER_NAME)'..."
	@k3d image import $(IMAGE) -c $(K3D_CLUSTER_NAME)
	@echo "Done."

k3d-remove-image:
	@if [ -z "$(IMAGE)" ]; then \
		echo "Please specify the image name using IMAGE=<name>:<tag>"; \
		exit 1; \
	fi
	@echo "🗑️ Removing image '$(IMAGE)' from all nodes in K3D cluster '$(K3D_CLUSTER_NAME)'..."
	@for node in $$(docker ps --format "{{.Names}}" | grep k3d-$(K3D_CLUSTER_NAME)); do \
		echo "🔸 Removing from $$node..."; \
		docker exec -i $$node crictl rmi $(IMAGE); \
	done
	@echo "Image '$(IMAGE)' removed from all cluster nodes."

k3d-images-list:
	@docker exec -it k3d-dev-cluster-server-0 crictl images
