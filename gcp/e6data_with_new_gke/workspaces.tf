module workspaces {
  providers = {
    kubernetes = kubernetes.gke_e6data
    helm       = helm.gke_e6data
  }

  source = "./modules/workspaces"

  gke_cluster_id = module.gke_e6data.gke_cluster_id
   
  location    = var.gcp_region
  total_max_node_count = var.max_instances_in_nodepool
  spot_enabled         = var.spot_enabled

  workspace_name = var.workspaces.0.name
  e6data_workspace_name = local.e6data_workspace_name
  gcp_region = var.gcp_region
  workspace_write_role_name = local.workspace_write_role_name
  workspace_read_role_name = local.workspace_read_role_name
  buckets = var.buckets
  gcp_project_id = var.gcp_project_id
  platform_sa_email = var.platform_sa_email
  cluster_viewer_role_name = local.cluster_viewer_role_name
  workload_role_name = local.workload_role_name
  workloadIdentityUser_role_name = local.workload_role_name
  target_pool_role_name = local.target_pool_role_name

  helm_chart_version = var.helm_chart_version
  random_string = random_string.random.result
  control_plane_user = var.control_plane_user

  workspaces = var.workspaces

  buckets_read_role_name = local.workspace_read_role_name
  buckets_write_role_name = local.workspace_write_role_name

}