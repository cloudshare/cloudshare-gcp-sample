# <img src="./images/cloudshare-logo.png" alt="drawing" width="32" style="vertical-align: middle;"/> cloudshare-gcp-sample

An Example of setting up a GCP project using Terraform script and bash script

## Assumptions
* Project is attached to a billing account.
* Compute API is enabled.
* Basic knowledge of GCP

## Purpose
These scripts create a cluster on a gcp project, and install an echo-server ([image link](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/echoserver@sha256:5d99aa1120524c801bc8c1a7077e8f5ec122ba16b6dda1a5d3826057f67b9bcb/details?tab=info)) container on that cluster with ingress access.

The terraform scripts does the following steps:
1. Creates a service account key for the project's default service account.
2. Adds permissions for the default service account (`roles/owner` and `roles/container.admin`).
3. Enable `container.googleapis.com` API for project.
4. Create a vm instance with a startup-script which clone a repository and runs a bash script from that repository.
5. The final part of the bash script (`main.sh`) is deleting the vm instance.

If the script run is successful, a service will be enabled on the cluster and navigating to it will return an echo of the request (take the url from the services tab in GKE section in the google console).

## How to use
* Fork this repository
* Update the script `main.sh` - add any GCP command needed.
* Update the local variable "git_repository_url" in `main.tf`. Set it to the newly created git repository (instead of 'https://github.com/cloudshare/${var.git_repository_name}' use your own repo).
* Update the Terraform script as needed (i.e, if you don't want to create a cluster in your porject, remove the project resource from the `main.tf` file)

## How to pass parameters from the Terraform script to the bash script
When running `main.sh` script, you can pass parameters to it (see line-6 in `main.tf`). The parameters are used by their index (start at $1). In the provided example, zone is passed as the second argument - $2.

## Running Locally
* Make sure gcloud is installed on local machine, and gcp user is logged in (by running `gcloud auth login` or `gcloud init`)
* Clone repository to local machine
* Uncomment the section under "uncomment here to run locally"
* Replace project id with "REPLACE_WITH_YOUR_PROJECT" inside project variable
