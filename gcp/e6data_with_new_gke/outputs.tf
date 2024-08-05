output "workspaces" {
  value = [for workspace in var.workspaces : workspace.name]
}

output "region" {
  value = var.gcp_region
}

output "workspace_gcs_bucket_names" {
  value = google_storage_bucket.workspace_bucket[*].name
}

output "gcp_project_id" {
  value = var.gcp_project_id
}

output "kubernetes_cluster_name" {
  value = module.gke_e6data.cluster_name
}

output "kubernetes_namespaces" {
  value = [for workspace in var.workspaces : workspace.namespace]
}

output "kubernetes_cluster_zone" {
  value = var.kubernetes_cluster_zone
}