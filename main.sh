#! /bin/bash
bash ./install-infra.sh

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

# kubectl set context
kubectl config set-context --current --namespace=not-default

# create echo service
kubectl run echo-cloudshare --image=gcr.io/google_containers/echoserver:1.4 --port=8080

# allow ingress 
kubectl expose deployment echo-cloudshare --type=LoadBalancer --port 80 --target-port 8080

# collect logs
zone=$(gcloud compute instances list --filter=$1 --format='value(zone)')
gcloud compute instances get-serial-port-output $1 --zone=$zone > ./serialPortLog.txt
curl -F 'data=@./serialPortLog.txt' 'https://use.cloudshare.com/api/v3/unauthenticated/TestPageLogging'

# delete the machine running this script
gcloud compute instances delete $1 --zone=$zone --quiet