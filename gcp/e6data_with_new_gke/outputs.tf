output "workspace_name" {
  value = var.workspace_name
}

output "region" {
  value = var.gcp_region
}

output "workspace_gcs_bucket_name" {
  value = module.default_workspace.workspace_gcs_bucket_name
}

output "gcp_project_id" {
  value = var.gcp_project_id
}

output "kubernetes_cluster_name" {
  value = module.gke_e6data.cluster_name
}

output "kubernetes_namespace" {
  value = var.kubernetes_namespace
}

output "kubernetes_cluster_zone" {
  value = var.kubernetes_cluster_zone
}

output "additional_workspaces" {
  value = [for workspace in var.additional_workspaces : workspace.name]
}

output "additional_namespaces" {
  value = [for workspace in var.additional_workspaces : workspace.namespace]
}

output "additional_bucket_names" {
  value = module.additional_workspaces.workspace_bucket_names
}