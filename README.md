# <img src="./images/cloudshare-logo.png" alt="drawing" width="32" style="vertical-align: middle;"/> cloudshare-gcp-sample

An Example of setting up a GCP project using Terraform script and bash script

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
