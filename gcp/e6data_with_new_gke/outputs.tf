output "region" {
  value = var.gcp_region
}

output "gcp_project_id" {
  value = var.gcp_project_id
}

output "kubernetes_cluster_name" {
  value = module.gke_e6data.cluster_name
}

output "kubernetes_cluster_zone" {
  value = var.kubernetes_cluster_zone
}

output "workspaces" {
  value = [for workspace in var.workspaces : workspace.name]
}

output "namespaces" {
  value = [for workspace in var.workspaces : workspace.namespace]
}

output "bucket_names" {
  value = module.workspaces.workspace_bucket_names
}