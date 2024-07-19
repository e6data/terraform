output "cluster_id" {
  description = "AKS Cluster ID"
  value       = azurerm_kubernetes_cluster.aks_e6data.id
}

output "cluster_name" {
  description = "AKS Cluster Name"
  value       = azurerm_kubernetes_cluster.aks_e6data.name
}

output "host" {
  value = azurerm_kubernetes_cluster.aks_e6data.kube_config.0.host
}

output "aks_principal_id" {
  value = azurerm_kubernetes_cluster.aks_e6data.identity[0].principal_id
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks_e6data.kube_config.0.cluster_ca_certificate
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks_e6data.kube_config.0.client_certificate
}

output "client_key" {
  value = azurerm_kubernetes_cluster.aks_e6data.kube_config.0.client_key
}

output "kube_version" {
  value = azurerm_kubernetes_cluster.aks_e6data.kubernetes_version
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.aks_e6data.oidc_issuer_url
}

output "aci_connector_object_id" {
  value = azurerm_kubernetes_cluster.aks_e6data.aci_connector_linux[0].connector_identity[0].object_id
}

output "aks_managed_rg_id" {
  value = azurerm_kubernetes_cluster.aks_e6data.node_resource_group_id
}

output "aks_rg_name" {
  value = azurerm_kubernetes_cluster.aks_e6data.resource_group_name
}

output "aks_managed_rg_name" {
  value = azurerm_kubernetes_cluster.aks_e6data.node_resource_group
}

output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.aks_e6data.kubelet_identity[0].object_id
}

output "user_assigned_identity_id" {
  value = azurerm_kubernetes_cluster.aks_e6data.kubelet_identity[0].user_assigned_identity_id
}

output "generated_cluster_public_ssh_key" {
  description = "The cluster will use this generated public key as ssh key when `var.public_ssh_key` is empty or null. The fingerprint of the public key data in OpenSSH MD5 hash format, e.g. `aa:bb:cc:....` Only available if the selected private key format is compatible, similarly to `public_key_openssh` and the [ECDSA P224 limitations](https://registry.terraform.io/providers/hashicorp/tls/latest/docs#limitations)."
  value       = try(azurerm_kubernetes_cluster.aks_e6data.linux_profile[0], null) != null ? (var.public_ssh_key == "" || var.public_ssh_key == null ? tls_private_key.ssh[0].public_key_openssh : null) : null
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.aks_e6data.kube_config_raw
}