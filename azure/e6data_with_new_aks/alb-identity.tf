# User Managed Identity for ALB Controller
resource "azurerm_user_assigned_identity" "alb_identity" {
  count = var.agfc_enabled ? 1 : 0

  name                = "${var.prefix}-azure-alb-identity"
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  location            = data.azurerm_resource_group.aks_resource_group.location

  tags = merge(var.cost_tags, var.agfc_tags)
}

# Add a time delay to allow identity replication in Microsoft Entra ID
resource "time_sleep" "wait_for_identity_replication" {
  count = var.agfc_enabled ? 1 : 0

  create_duration = "60s"
  
  depends_on = [azurerm_user_assigned_identity.alb_identity]
}

# Get the AKS node resource group ID
data "azurerm_resource_group" "aks_node_rg" {
  count = var.agfc_enabled ? 1 : 0
  name  = module.aks_e6data.aks_managed_rg_name
}

# Assign Reader role to the ALB identity on the AKS node resource group
resource "azurerm_role_assignment" "alb_identity_node_rg_reader" {
  count = var.agfc_enabled ? 1 : 0

  scope                = data.azurerm_resource_group.aks_node_rg[0].id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.alb_identity[0].principal_id
  
  depends_on = [time_sleep.wait_for_identity_replication]
}

# Federated credential for ALB Controller workload identity
# IMPORTANT: The name MUST be "azure-alb-identity" - this is a requirement from ALB Controller
resource "azurerm_federated_identity_credential" "alb_identity" {
  count = var.agfc_enabled ? 1 : 0

  name                = "azure-alb-identity" # This name is mandatory for ALB Controller
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  parent_id           = azurerm_user_assigned_identity.alb_identity[0].id
  audience            = ["api://AzureADTokenExchange"]
  
  # Use the OIDC issuer from the existing AKS cluster
  issuer  = module.aks_e6data.oidc_issuer_url
  subject = "system:serviceaccount:${var.alb_controller_namespace}:${var.alb_controller_service_account_name}"

  depends_on = [time_sleep.wait_for_identity_replication]
}

# Role assignment for subnet operations (needed for AGFC subnet association)
resource "azurerm_role_assignment" "alb_identity_network_contributor" {
  count = var.agfc_enabled ? 1 : 0

  scope                = module.network.vpc_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.alb_identity[0].principal_id
  
  depends_on = [time_sleep.wait_for_identity_replication]
}

# Delegate AppGw for Containers Configuration Manager role to AKS Managed Cluster RG
resource "azurerm_role_assignment" "alb_identity_agfc_config_manager" {
  count = var.agfc_enabled ? 1 : 0

  scope                = data.azurerm_resource_group.aks_node_rg[0].id
  role_definition_id   = "/providers/Microsoft.Authorization/roleDefinitions/fbc52c3f-28ad-4303-a892-8a056630b8f1" # AppGw for Containers Configuration Manager
  principal_id         = azurerm_user_assigned_identity.alb_identity[0].principal_id
  
  depends_on = [time_sleep.wait_for_identity_replication]
}

# Delegate Network Contributor permission for join to association subnet
resource "azurerm_role_assignment" "alb_identity_subnet_join" {
  count = var.agfc_enabled ? 1 : 0

  scope                = module.network.alb_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.alb_identity[0].principal_id
  
  depends_on = [time_sleep.wait_for_identity_replication]
}

# Delegate Network Contributor permission for join to internal association subnet
resource "azurerm_role_assignment" "alb_identity_internal_subnet_join" {
  count = var.agfc_enabled && var.agfc_internal_enabled ? 1 : 0

  scope                = module.network.alb_internal_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.alb_identity[0].principal_id
  
  depends_on = [time_sleep.wait_for_identity_replication]
}