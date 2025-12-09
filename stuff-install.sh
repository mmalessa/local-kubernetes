#!/bin/bash

FORCE=false

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "You are not root!"
    exit
fi

for arg in "$@"; do
    case $arg in
        --force)
            FORCE=true
            shift
            ;;
    esac
done

# K3D
if [ -x "$(command -v k3d)" ] && [ "$FORCE" = false ]; then
  echo "k3d found"
else
  echo "Download and install k3d..."
  wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

# KUBECTL
if [ -x "$(command -v kubectl)" ] && [ "$FORCE" = false ]; then
  echo "kubectl found"
else
  echo "Download and install kubectl..."
  wget -q -O - "https://dl.k8s.io/release/$(wget -q -O - https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" > /usr/local/bin/kubectl \
     && chmod +x /usr/local/bin/kubectl
fi

if [ -x "$(command -v kubectx)" ] && [ "$FORCE" = false ]; then
  echo "kubectx found"
else
  echo "Download and install kubectx..."
  sudo curl --silent -Lo /usr/local/bin/kubectx https://github.com/ahmetb/kubectx/releases/latest/download/kubectx
  sudo chmod +x /usr/local/bin/kubectx
fi

if [ -x "$(command -v kubens)" ] && [ "$FORCE" = false ]; then
  echo "kubens found"
else
  echo "Download and install kubens..."
  sudo wget -q -O /usr/local/bin/kubens https://github.com/ahmetb/kubectx/releases/latest/download/kubens
  sudo chmod +x /usr/local/bin/kubens
fi

# K9S
if [ -x "$(command -v k9s)" ] && [ "$FORCE" = false ]; then
  echo "k9s found"
else
  echo "Download and install k9s..."
  wget -q -O - https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz | tar -xzf - k9s \
    && chmod +x k9s \
    && mv k9s /usr/local/bin/k9s
fi

# DevSpace
if [ -x "$(command -v devspace)" ] && [ "$FORCE" = false ]; then
  echo "devspace found"
else
  echo "Download and install devspace..."
  curl -s -L -o devspace "https://github.com/loft-sh/devspace/releases/latest/download/devspace-linux-amd64" \
    && sudo install -c -m 0755 devspace /usr/local/bin && rm ./devspace
fi

# Helm
if [ -x "$(command -v helm)" ] && [ "$FORCE" = false ]; then
  echo "helm found"
else
  echo "Download and install helm..."
  curl --silent https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Helmfile
if [ -x "$(command -v helmfile)" ] && [ "$FORCE" = false ]; then
  echo "helmfile found"
else
  echo "Download and install helmfile..."
  release_url=$( curl -I "https://github.com/helmfile/helmfile/releases/latest" --silent | grep location: | grep -oP 'https?://\S+' )
  version=$(echo "$release_url" | grep -oP '\d+\.\d+\.\d+')
  echo "Latest helmfile version: ${version}"

  wget -q -O - https://github.com/helmfile/helmfile/releases/download/v${version}/helmfile_${version}_linux_amd64.tar.gz | tar -xzf - helmfile \
  && chmod +x helmfile \
  && mv helmfile /usr/local/bin/helmfile
fi

echo "DONE"