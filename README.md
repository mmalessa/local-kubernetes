# Learning K8s
See `Makefile` content ...or `make help`

## Kictstart
```sh
make stuff-install # install some linux stuff
make cluster-create
```

## Docker Registry UI
```sh
make make app-docker-registry-ui-deploy # deploy docker-registry-ui
```
Web browser: http://registry-ui.localhost


# Dev notes

### Kubernetes
```sh
kubectl create deployment nginx --image=nginx:latest --port 80
kubectl expose deployment nginx --port 80
kubectl get svc,po
kubectl create ingress nginx --rule="nginx.localhost/=nginx:80"
kubectl get ingress
```

### Helm
```sh
helm create mychart
helm install myapp ./mychart
```

### K3d
```shell
k3d cluster list
k3d cluster create mycluster
k3d cluster delete mycluster
k3d cluster start mycluster
k3d cluster stop mycluster
```