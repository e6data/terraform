output "cluster_name" {
  description = "AKS Cluster Name"
  value       = azurerm_kubernetes_cluster.aks_engine.id
}

output "host" {
  value = azurerm_kubernetes_cluster.aks_engine.kube_config.0.host
}

output "aks_principal_id" {
  value = azurerm_kubernetes_cluster.aks_engine.identity[0].principal_id
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks_engine.kube_config.0.cluster_ca_certificate
}

output "kube_version" {
  value = azurerm_kubernetes_cluster.aks_engine.kubernetes_version
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.aks_engine.oidc_issuer_url
}

output "aci_connector_object_id" {
  value = azurerm_kubernetes_cluster.aks_engine.aci_connector_linux[0].connector_identity[0].object_id
}

output "aks_managed_rg_id" {
  value = azurerm_kubernetes_cluster.aks_engine.node_resource_group_id
}

output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.aks_engine.kubelet_identity[0].object_id
}