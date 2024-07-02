# Create user-assigned identity, which is used by the karpenter.
resource "azurerm_user_assigned_identity" "karpenter" {
  location            = data.azurerm_resource_group.aks_resource_group.location
  name                = "${var.workspace_name}-karpenter-identity"
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  tags                = local.default_tags
}

# This resource block creates a federated identity credential, which will be used for authentication and authorization from the AKS.
resource "azurerm_federated_identity_credential" "karpenter_federated_credential" {
  name                = "${var.workspace_name}-karpenter-federated-credential"
  audience            = ["api://AzureADTokenExchange"]
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  issuer              = data.azurerm_kubernetes_cluster.this.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.karpenter.id
  subject             = "system:serviceaccount:${var.karpenter_namespace}:${var.karpenter_service_account_name}"
}

# role assignment to provide permission to karpenter
resource "azurerm_role_assignment" "karpenter_roles" {
  for_each = toset([
    "Virtual Machine Contributor",
    "Network Contributor",
    "Managed Identity Operator"
  ])

  principal_id         = azurerm_user_assigned_identity.karpenter.principal_id
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${module.aks_e6data.node_resource_group}"
  role_definition_name = each.key
}

module "karpenter" {
  source                  = "./modules/karpenter"
  provider                 = helm.e6data
  
  depends_on = [module.network]
}