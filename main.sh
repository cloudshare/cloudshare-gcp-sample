#! /bin/bash
bash ./cloudshare-gcp-sample/install-infra.sh

# project and service account variables if you need them for env-variables files
PROJECT="$(gcloud config get-value project)"
SA="$(gcloud config get-value account)"

# this is done to use the service account credentials (in this case, the key in creds.json)
# see: https://github.com/kubernetes/kubernetes/issues/30617
gcloud config set container/use_client_certificate False

# create .kube/config
mkdir /.kube
touch /.kube/config
chmod -R 777 /.kube
export KUBECONFIG=/.kube/config

# get container credentials
gcloud container clusters get-credentials echo-cloudshare --zone $2 --project $PROJECT

# create echo service
kubectl run echo-cloudshare --image=gcr.io/google_containers/echoserver:1.4 --port=8080

# allow ingress 
kubectl expose deployment echo-cloudshare --type=LoadBalancer --port 80 --target-port 8080

# delete the machine running this script
gcloud compute instances delete $1 --zone=$zone --quiet