# <img src="./images/cloudshare-logo.png" alt="drawing" width="32" style="vertical-align: middle;"/> cloudshare-gcp-sample

A sample for setting up a GCP project using terraform script and bash script

## How to use
* Fork this repository
* Update the script with the actions you want to do
* Update local variable "git_repository_url" in main.tf
* Update the terraform script if needed (i.e, if you don't want to create a cluster in your porject, remove the project resource from the main.tf file)

## How to pass variables from the terraform script to the bash script
When running the main.sh, you can pass arguments to file (see line-6 in main.tf), to use the passed arguments by their index (start at $1). In the provided example, zone is passed as the second argument - $2.

## Running Locally
* Make sure gcloud is installed on local machine, and gcp user is logged in (by running gcloud auth login or gcloud init)
* Clone repository to local machine
* Uncomment the section under "uncomment here to run locally"
* Replace project id with "REPLACE_WITH_YOUR_PROJECT" inside project variable

