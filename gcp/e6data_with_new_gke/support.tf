locals {
  workspaces = [for ws in var.workspaces : {
    e6data_workspace_name = "e6data-${substr(ws.name, 0, 4)}"
    name = ws.name
    namespace = ws.namespace
    spot_nodepool_instance_type = ws.spot_nodepool_instance_type
    ondemand_nodepool_instance_type = ws.ondemand_nodepool_instance_type
    ondemand_highmem_nodepool_instance_type = ws.ondemand_highmem_nodepool_instance_type
    serviceaccount_create  = ws.serviceaccount_create
    serviceaccount_email  = ws.serviceaccount_email
    buckets  = ws.buckets
    max_instances_in_nodepool = ws.max_instances_in_nodepool
    cost_labels = ws.cost_labels
  }]

  workspaces_with_sa = [for ws in var.workspaces : ws if ws.serviceaccount_create]
  service_accounts = {
    for idx, workspace in local.workspaces_with_sa : 
    workspace.name => google_service_account.workspace_sa[idx].email
  }

  workspaces_with_star_buckets = {
    for idx, ws in local.workspaces : idx => ws
    if contains(ws.buckets, "*")
  }

  workspaces_without_star_buckets = {
    for idx, ws in local.workspaces : idx => ws
    if !contains(ws.buckets, "*")
  }

  workspace_bucket_bindings = flatten([
    for idx, workspace in local.workspaces_without_star_buckets :
    [
      for bucket in workspace.buckets :
      {
        workspace = workspace
        bucket    = bucket
        idx       = idx
      }
    ]
  ])

  member_emails = {
    for idx, workspace in local.workspaces :
    idx => workspace.serviceaccount_create ? google_service_account.workspace_sa[idx].email : workspace.serviceaccount_email
  }
  workspace_role_name         = replace(var.workspaces[0].name, "-", "_")
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
  count    = length(var.workspaces)
  length  = 5
  special = false
  lower   = true
  upper   = false
}

data "google_project" "current" {
}

data "google_client_config" "default" {}