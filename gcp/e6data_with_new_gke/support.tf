locals {
  workspaces = [for ws in var.workspace_names : {
    e6data_workspace_name = "e6data-${substr(ws.name, 0, 4)}"
    name = ws.name
    namespace = ws.namespace
    nodepool_instance_type = ws.nodepool_instance_type
    max_instances_in_nodepool = ws.max_instances_in_nodepool
    spot_enabled = ws.spot_enabled
    cost_labels = ws.cost_labels
  }]
  
  workspace_role_name         = replace(var.workspace_names[0].name, "-", "_")
  workspace_write_role_name   = "e6data_${local.workspace_role_name}_write"
  workspace_read_role_name    = "e6data_${local.workspace_role_name}_read"
  cluster_viewer_role_name    = "e6data_${local.workspace_role_name}_cluster_viewer"
  workload_role_name          = "e6data_${local.workspace_role_name}_workload_identity_user"
  target_pool_role_name       = "e6data_${local.workspace_role_name}_targetpool_read"
  security_policy_role_name   = "e6data_${local.workspace_role_name}_security_policy"
  global_address_role_name    = "e6data_${local.workspace_role_name}_globaladdress_policy"
  kubernetes_cluster_location = var.kubernetes_cluster_zone != "" ? var.kubernetes_cluster_zone : var.gcp_region
  helm_values_file = yamlencode({
    cloud = {
      type               = "GCP"
      oidc_value         = google_service_account.workspace_sa.email
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

data "google_client_config" "default" {}
