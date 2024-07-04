# Learning K8s
See `Makefile` content ...or `make help`

## kictstart
```sh
make stuff-install # install some linux stuff
make cluster-create
```


# Dev notes

### Kubernetes
```shell
kubectl create deployment nginx --image=nginx:latest --port 80
kubectl expose deployment nginx --port 80
kubectl get svc,po
kubectl create ingress nginx --rule="nginx.localhost/=nginx:80"
kubectl get ingress
```

### Helm
```shell
helm create mychart
helm install myapp ./mychart
```