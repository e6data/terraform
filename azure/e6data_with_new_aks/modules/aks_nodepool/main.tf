# Create a node pool in the AKS cluster
resource "azurerm_kubernetes_cluster_node_pool" "e6data_node_pool" {
  name                    = var.nodepool_name
  kubernetes_cluster_id   = var.aks_cluster_name
  vm_size                 = var.vm_size
  enable_auto_scaling     = var.enable_auto_scaling
  min_count               = var.min_number_of_nodes
  max_count               = var.max_number_of_nodes
  tags                    = var.tags
  vnet_subnet_id          = var.vnet_subnet_id
  zones                   = var.zones
  orchestrator_version    = var.kube_version

  priority                = var.priority

  spot_max_price          = var.priority == "Spot" ? var.spot_max_price : null
  eviction_policy         = var.priority == "Spot" ? var.eviction_policy : null
  
  node_labels = local.node_labels

  lifecycle {
    ignore_changes = [
      kubernetes_cluster_id
    ]
  }
  
  node_taints = local.node_taints
}