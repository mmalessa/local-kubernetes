# Local Kubernetes
Based on [K3D](https://k3d.io)

Kubernetes Cluster running in Docker - for developer needs

Just 'make up'... (almost) that's it :D

See `Makefile` content ...or `make help`

## Basic commands
```sh
make stuff-install # install some linux stuff
make up
make down
```

## Customize cluster.yaml (optional)

Set your local 'projects' directory


```yaml
  runtime:
    volumes:
    - /home/projects:/mnt/projects@all  # Your projects directory
```
you can mount custom project into container in Kubernetes e.g.
```yaml
apiVersion: v1
kind: Pod
metadata:
    name: dev-php
spec:
    containers:
        - name: php-dev
          image: registry.localhost:5000/learning-symfony-messenger-php:latest
          command: ["tail", "-f", "/dev/null"]
          volumeMounts:
              - name: php-source
                mountPath: /app # directory in container
    volumes:
        - name: php-source
          hostPath:
              path: /mnt/projects/learning-symfony-messenger # <-- here
              type: Directory
```

## Access to Docker Registry UI
```
http://registry-ui.localhost/
```

