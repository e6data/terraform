terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.17.0"
    }
  }
}

# Comment out this block if storing Terraform state is required.
provider "google" {
  project        = var.gcp_project_id
  region         = var.gcp_region
  default_labels = var.cost_labels
  credentials = "{{GOOGLE_CLOUD_KEYFILE_JSON}}"
  # access_token = "{{ gcp_access_token }}"
}

# Uncomment this block if storing Terraform state is required & update the bucket name.

#provider "google" {
#    project = var.gcp_project_id
#    region = var.gcp_region
#    credentials = "{{GOOGLE_CLOUD_KEYFILE_JSON}}"
#    access_token = "{{ gcp_access_token }}"
#
#  backend "gcs" {
#    bucket  = "<bucket_name_to_store_the_tfstate_file>"
#    prefix  = "terraform/state"
#  }
#}