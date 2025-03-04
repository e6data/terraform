locals {
  short_workspace_name        = substr(var.workspace_name, 0, 4)
  e6data_workspace_name       = "e6data-${local.short_workspace_name}"
  workspace_role_name         = replace(var.workspace_name, "-", "_")
  workspace_write_role_name   = "e6data_${local.workspace_role_name}_write"
  workspace_read_role_name    = "e6data_${local.workspace_role_name}_read"
  cluster_viewer_role_name    = "e6data_${local.workspace_role_name}_cluster_viewer"
  workload_role_name          = "e6data_${local.workspace_role_name}_workload_identity_user"
  target_pool_role_name       = "e6data_${local.workspace_role_name}_targetpool_read"
  kubernetes_cluster_location = var.kubernetes_cluster_zone != "" ? var.kubernetes_cluster_zone : var.gcp_region
  helm_values_file = yamlencode({
    cloud = {
      type               = "GCP"
      oidc_value         = google_service_account.workspace_sa.email
      control_plane_user = var.control_plane_user
      debug_namespaces   = var.debug_namespaces
    }
  })

}

resource "random_string" "random" {
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