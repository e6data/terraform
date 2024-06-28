module "autoscaler_deployment" {
  providers = {
    kubernetes = kubernetes.gke_e6data
    helm       = helm.gke_e6data
  }

  source = "./modules/autoscaler"

  helm_chart_name = "autoscaler"
  helm_chart_version = var.autoscaler_helm_chart_version

  namespace = var.autoscaler_namespace
  service_account_name = var.autoscaler_service_account_name

  cluster_name = module.gke_e6data.cluster_name
  nodepool_name = google_container_node_pool.workspace.name

  gcp_project_id = var.gcp_project_id

  tolerations_key    = "e6data-workspace-name"
  tolerations_value  = var.workspace_name


  depends_on = [module.gke_e6data, google_container_node_pool.default_gke_cluster_nodepool]
}