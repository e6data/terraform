terraform {
  backend "s3" {
    bucket = "internal-terraform-state"
    key    = "gcp/state.tfstate"
    region = "us-east-1"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.16.0"
    }
  }
}

# Comment out this block if storing Terraform state is required.
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  credentials = "/home/ec2-user/e6-infra-internal/terraform-gcp/values/gcp_sa.json"
  default_labels = var.cost_labels
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = var.gcp_region
  credentials = "/home/ec2-user/e6-infra-internal/terraform-gcp/values/gcp_sa.json"
  default_labels = var.cost_labels
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