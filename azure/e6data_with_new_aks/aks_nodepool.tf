# Create a node pool in the AKS cluster
module "nodepool" {
  source = "./modules/aks_nodepool"

  nodepool_name       = var.workspace_name
  aks_cluster_name    = module.aks_e6data.cluster_name
  vm_size             = var.vm_size
  kube_version        = module.aks_e6data.kube_version
  enable_auto_scaling = var.enable_auto_scaling
  min_number_of_nodes = var.min_size
  max_number_of_nodes = var.max_size
  vnet_subnet_id      = module.network.aks_subnet_id
  zones               = var.zones
  priority            = var.priority
  spot_max_price      = var.spot_max_price
  eviction_policy     = var.spot_eviction_policy
  tags = merge(
    {
      namespace = var.kubernetes_namespace
    },
    var.cost_tags
  )
  depends_on = [module.network]

}


# Create user-assigned identity, which is used by the engine to access data buckets.
resource "azurerm_user_assigned_identity" "e6data_identity" {
  location            = data.azurerm_resource_group.aks_resource_group.location
  name                = "${var.prefix}-${var.workspace_name}-identity"
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  tags                = var.cost_tags
}

# This resource block creates a federated identity credential, which will be used for authentication and authorization from the AKS.
resource "azurerm_federated_identity_credential" "e6data_federated_credential" {
  name                = "${var.prefix}-${var.workspace_name}-federated-credential"
  audience            = ["api://AzureADTokenExchange"]
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  issuer              = module.aks_e6data.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.e6data_identity.id
  subject             = "system:serviceaccount:${var.kubernetes_namespace}:${var.workspace_name}"
}

resource "azurerm_role_assignment" "e6data_engine_write_role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.e6data_identity.principal_id
}

