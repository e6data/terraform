output "workspace_name" {
  value = var.workspace_name
}

output "region" {
  value = var.gcp_region
}

output "workspace_gcs_bucket_name" {
  value = local.e6data_workspace_name
}

output "gcp_project_id" {
  value = var.gcp_project_id
}

output "kubernetes_cluster_name" {
  value = var.cluster_name
}

output "kubernetes_namespace" {
  value = var.kubernetes_namespace
}

output "kubernetes_cluster_zone" {
  value = var.kubernetes_cluster_zone
}