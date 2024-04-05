
APP_CLUSTER_NAME=dev-cluster

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
.PHONY: k3d-cluster-list k3d-cluster-create k3d-cluster-delete k3d-cluster-stop k3d-cluster-start
k3d-cluster-list: ## k3d cluster list
	@k3d cluster list
k3d-cluster-create: ## k3d cluster create
	@k3d cluster create $(filter-out $@,$(MAKECMDGOALS))
k3d-cluster-delete: ## k3d cluster delete
	@k3d cluster delete $(filter-out $@,$(MAKECMDGOALS))
k3d-cluster-start: ## k3d cluster start
	@k3d cluster start $(filter-out $@,$(MAKECMDGOALS))
k3d-cluster-stop: ## k3d cluster stop
	@k3d cluster stop $(filter-out $@,$(MAKECMDGOALS))

### App cluster
.PHONY: cluster-init cluster-check cluster-delete cluster-list
cluster-init: ## Init cluster
	@echo "Init cluster: $(APP_CLUSTER_NAME)"
	# k3d cluster create $(APP_CLUSTER_NAME) --port 8080:80@loadbalancer
	k3d cluster create --config kubernetes/cluster.yaml

cluster-delete: ## Delete cluster
	@echo "Delete cluster: $(APP_CLUSTER_NAME)"
	k3d cluster delete $(APP_CLUSTER_NAME)

cluster-list: ## List clusters
	k3d cluster list

cluster-check: ## Check cluster
	@echo "Check cluster: $(APP_CLUSTER_NAME)"
	@echo "------------------------------"
	kubectl get pods --output wide
	@echo "------------------------------"
	kubectl get ingress --output wide
	@echo "------------------------------"
	kubectl get services --output wide
	@echo "------------------------------"

### Apps
# https://containers.fan/posts/using-k3d-to-run-development-kubernetes-clusters/
.PHONY: app-hostname-deploy app-hostname-ping
app-hostname-deploy: ## Deploy app: hostname
	kubectl apply -f deployments/hostname-app/deployment.yaml

app-hostname-delete: ## Delete app: hostname
	kubectl delete deployment hostname
	kubectl delete ingress hostname-ingress
	kubectl delete services hostname-service
	
app-hostname-ping: ## Ping 
	curl http://hostname.127.0.0.1.nip.io:80


.PHONY: app-debian-deploy
app-debian-deploy: ## Deploy app: debian
	kubectl apply -f deployments/debian/deployment.yaml
