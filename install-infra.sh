#! /bin/bash
# kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# uncomment if you want to install helm with a specific version
# helm version 2.12.3
# wget  -P ./ "https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz"
# tar -zxvf helm-v2.12.3-linux-amd64.tar.gz
# mv ./linux-amd64/helm /bin/helm