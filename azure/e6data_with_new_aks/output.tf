
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
  value = azuread_application.e6data_app.application_id
}

output "secret" {
  sensitive = true
  value = azuread_application_password.e6data_secret.value
}

output "resource_group" {
  value = var.aks_resource_group_name
}

output "subscription_id" {
  value = var.subscription_id
}

output "kubernetes_cluster_name" {
  value = module.aks_e6data.cluster_name_short
}

output "kubernetes_namespace" {
  value = var.kubernetes_namespace
}