locals {
  e6data_workspace_name = "e6data-workspace-${var.workspace_name}"
  workspace_role_name = replace(var.workspace_name, "-", "_")
  workspace_write_role_name = "e6data_${local.workspace_role_name}_write"
  workspace_read_role_name = "e6data_${local.workspace_role_name}_read"
  cluster_viewer_role_name = "e6data_${local.workspace_role_name}_cluster_viewer"
  workload_role_name = "e6data_${local.workspace_role_name}_workload_identity_user"

  kubernetes_cluster_location = var.gcp_region

  helm_values_file =yamlencode({
    cloud = {
      type = "GCP"
      oidc_value = google_service_account.workspace_sa.email
      control_plane_user = var.control_plane_user
    }
  })
   
}

data "google_project" "current" {
}

data "google_client_config" "default" {}
