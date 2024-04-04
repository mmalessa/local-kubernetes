#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "You are not root!"
    exit
fi

# K3D
wget -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# KUBECTL
wget -O - "https://dl.k8s.io/release/$(wget -q -O - https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" > /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl

# K9S
wget -O - https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz | tar -xzf - k9s \
    && chmod +x k9s \
    && mv k9s /usr/bin/k9s