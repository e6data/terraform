locals {
  # short_workspace_name        = substr(var.workspace_name, 0, 4)
  # e6data_workspace_name       = "e6data-${local.short_workspace_name}"
  kubernetes_cluster_location = var.kubernetes_cluster_zone != "" ? var.kubernetes_cluster_zone : var.gcp_region

  helm_values_file = yamlencode({
    cloud = {
      type               = "GCP"
      oidc_value         = var.workspace_sa_email
      control_plane_user = var.control_plane_user
    }
  })

}

resource "random_string" "random" {
  count    = length(var.workspace_names)
  length  = 5
  special = false
  lower   = true
  upper   = false
}

data "google_project" "current" {
}

data "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = local.kubernetes_cluster_location
}

data "google_client_config" "default" {}

provider "helm" {
  alias = "gke_e6data"
  kubernetes {
    host                   = "https://${data.google_container_cluster.gke_cluster.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate)
  }
}