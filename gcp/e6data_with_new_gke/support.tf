locals {
  short_workspace_name        = substr(var.workspace_name, 0, 4)
  e6data_workspace_name       = "e6data-${local.short_workspace_name}"
  workspace_role_name         = replace(var.workspace_name, "-", "_")
  workspace_write_role_name   = "e6data_${local.workspace_role_name}_write"
  workspace_read_role_name    = "e6data_${local.workspace_role_name}_read"
  cluster_viewer_role_name    = "e6data_${local.workspace_role_name}_cluster_viewer"
  workload_role_name          = "e6data_${local.workspace_role_name}_workload_identity_user"
  target_pool_role_name       = "e6data_${local.workspace_role_name}_targetpool_read"
  security_policy_role_name   = "e6data_${local.workspace_role_name}_security_policy"
  global_address_role_name    = "e6data_${local.workspace_role_name}_globaladdress_policy"
  kubernetes_cluster_location = var.kubernetes_cluster_zone != "" ? var.kubernetes_cluster_zone : var.gcp_region

}

resource "random_string" "random" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}

data "google_project" "current" {
}

data "google_client_config" "default" {}
