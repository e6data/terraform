output "gke_nodepool_name" {
  value = local.e6data_workspace_name
}

output "gke_nodepool_max_instances" {
  value = var.max_instances_in_nodegroup
}

output "region" {
  value = var.gcp_region
}

output "kubernetes_cluster_zone" {
  value = var.kubernetes_cluster_zone
}

output "workspace_gcs_bucket_name" {
  value = local.e6data_workspace_name
}

output "e6data_workspace_name" {
  value = var.workspace_name
}

output "kubernetes_cluster_name" {
  value = var.cluster_name
}

output "kubernetes_namespace_for_e6data_workspace" {
  value = var.kubernetes_namespace
}

output "gcp_project_id" {
  value = var.gcp_project_id
}