# Learning K8s
See `Makefile` content ...or `make help`


# GUI
## hostname
http://hostname.localhost



# Notes
```shell
kubectl create deployment nginx --image=nginx:latest --port 80
kubectl expose deployment nginx --port 80
kubectl get svc,po
kubectl create ingress nginx --rule="nginx.localhost/=nginx:80"
kubectl get ingress
```

```shell
helm create mychart
helm install myapp ./mychart
```