#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "You are not root!"
    exit
fi

# K3D
if [ -x "$(command -v k3d)" ]; then
  echo "k3d found"
else
  echo "k3d not found. Download and install..."
  wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

# KUBECTL
if [ -x "$(command -v kubectl)" ]; then
  echo "kubectl found"
else
  echo "kubectl not found. Download and install..."
  wget -q -O - "https://dl.k8s.io/release/$(wget -q -O - https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" > /usr/local/bin/kubectl \
     && chmod +x /usr/local/bin/kubectl
fi

# K9S
if [ -x "$(command -v k9s)" ]; then
  echo "k9s found"
else
  echo "k9s not found. Download and install..."
  wget -q -O - https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz | tar -xzf - k9s \
    && chmod +x k9s \
    && mv k9s /usr/local/bin/k9s
fi

# DevSpace
if [ -x "$(command -v devspace)" ]; then
  echo "devspace found"
else
  echo "devspace not found. Download and install..."
  curl -s -L -o devspace "https://github.com/loft-sh/devspace/releases/latest/download/devspace-linux-amd64" \
    && sudo install -c -m 0755 devspace /usr/local/bin && rm ./devspace
fi