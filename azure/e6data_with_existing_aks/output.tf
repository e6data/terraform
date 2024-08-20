
output "workspace_name" {
  value = var.workspace_name
}

output "region" {
  value = data.azurerm_resource_group.aks_resource_group.location
}

output "blob_storage_container_path" {
  value = local.blob_storage_container_path
}

output "tenant_id" {
  sensitive = true
  value = data.azurerm_client_config.current.tenant_id
}

output "client_id" {
  sensitive = true
  value = azurerm_user_assigned_identity.federated_identity.client_id
}

output "resource_group" {
  value = var.aks_resource_group_name
}

output "subscription_id" {
  value = var.subscription_id
}

output "kubernetes_cluster_name" {
  value = data.azurerm_kubernetes_cluster.aks_e6data.name
}

output "kubernetes_namespace" {
  value = var.kubernetes_namespace
}