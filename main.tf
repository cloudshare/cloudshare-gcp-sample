# uncomment here to run locally
# variable "project" {
#   default = "REPLACE_WITH_YOUR_PROJECT"
# }

# provider "google" {
#     zone    = "${var.zone}"
#     project = "${var.project}"
# }

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "instance_name" {
  default = "gcp-ubuntu"
}

variable "git_repository_name" {
  default = "cloudshare-gcp-sample"
}

locals {
  git_repository_url = "https://github.com/cloudshare/${var.git_repository_name}"
}

data "google_project" "project" {}

data "google_compute_default_service_account" "default" { 
}

resource "google_service_account_key" "mykey" {
  service_account_id = "${data.google_compute_default_service_account.default.email}"

  depends_on = ["data.google_compute_default_service_account.default"]
}

resource "google_project_iam_binding" "my-project-owner" {
  project                     = "${data.google_project.project.id}"
  role    = "roles/owner"

  members = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}"
  ]
}

resource "google_project_iam_binding" "my-project-container-admin" {
  project                     = "${data.google_project.project.id}"
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${data.google_compute_default_service_account.default.email}"
  ]
}

locals {
    json-decoded = "${jsonencode(base64decode(google_service_account_key.mykey.private_key))}"
    sa-email = "${data.google_compute_default_service_account.default.email}"
    fixed-key = "${replace(replace(replace(local.json-decoded, "\\\\n", "$$$"), "\\n", ""), "$$$", "\\\\n")}"
}


resource "google_project_service" "enable_gke" {
  project                     = "${data.google_project.project.id}"
  service                     = "container.googleapis.com"

  #disable_dependent_services  = false
  disable_on_destroy          = false
}

resource "google_container_cluster" "my_cluster" {
  name     = "echo-cloudshare"
  zone = "${var.zone}"

  initial_node_count = 1

  depends_on = [ "google_project_service.enable_gke" ]
}

# uncomment if you want to create a static IP as part of the terraform script
# resource "google_compute_address" "static" {
#   name    = "ip-1"
#   region  = "${var.region}"
# }

# these are the lines for the startup-script (written here for ease of use\read)
locals {
  line-0  = "#! /bin/bash"
  line-1  = "echo ${local.fixed-key} > /creds.json"
  line-2  = "gcloud config set account ${local.sa-email}"
  line-3  = "gcloud auth activate-service-account ${local.sa-email} --key-file=/creds.json"
  line-4  = "git clone ${local.git_repository_url}"
  line-5  = "chmod -R 777 ./${var.git_repository_name}"
  line-6  = "yes y | bash ./${var.git_repository_name}/main.sh ${var.instance_name} ${var.zone}"
}

resource "google_compute_instance" "worker_instance" {
  name          = "${var.instance_name}"
  machine_type  = "n1-standard-4"
  zone          = "${var.zone}"

  boot_disk {
    initialize_params {      
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  scheduling {
    preemptible = false
  }
  
  metadata {
    startup-script = "${local.line-0}\n${local.line-1}\n${local.line-2}\n${local.line-3}\n${local.line-4}\n${local.line-5}\n${local.line-6}",
    # adding this label to hide from viewer
    kube-labels = "cloud.google.com/gke-nodepool" 
  }

  depends_on = [  "google_project_iam_binding.my-project-owner",
                  "google_project_iam_binding.my-project-container-admin",
                  "google_container_cluster.my_cluster" ]
}