# Create an Azure user assigned identity
resource "azurerm_user_assigned_identity" "federated_identity" {
  location            = data.azurerm_resource_group.aks_resource_group.location
  name                = "${var.workspace_name}-federated-${random_string.random.result}"
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  tags                = var.cost_tags
}

resource "azurerm_federated_identity_credential" "federated_credential" {
  name                = "e6data-cognito"
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  audience            = ["${var.identity_pool_id}"]
  issuer              = "https://cognito-identity.amazonaws.com"
  parent_id           = azurerm_user_assigned_identity.federated_identity.id
  subject             = "${var.identity_id}"

  depends_on = [ azurerm_user_assigned_identity.federated_identity ]
}

# custom role definition to provide key vault certificate access
resource "azurerm_role_definition" "e6data_customer_key_vault_custom_role" {
  count       = var.key_vault_name != "" ? 1 : 0
  name        = "e6data aks custom role customer key vault ${var.workspace_name} ${random_string.random.result}"
  description = "Custom role to read certificates from Key Vault"
  scope               = data.azurerm_key_vault.vault[0].id
  assignable_scopes = [
    data.azurerm_key_vault.vault[0].id
  ]
  
  permissions {
    data_actions = [
      "Microsoft.KeyVault/vaults/certificates/read"
    ]
    not_actions = []
  }
}

# custom role definition to provide key vault certificate access
resource "azurerm_role_definition" "e6data_key_vault_custom_role" {
  count               = var.key_vault_name == "" ? 1 : 0
  name        = "e6data aks custom role e6data key vault ${var.workspace_name} ${random_string.random.result}"
  description = "Custom role to read certificates from Key Vault"
  scope               = azurerm_key_vault.e6data_vault[0].id
  assignable_scopes = [
    azurerm_key_vault.e6data_vault[0].id
  ]
  
  permissions {
    data_actions = [
      "Microsoft.KeyVault/vaults/certificates/read"
    ]
    not_actions = []
  }
}

# service principal role assignment to provide key vault certificate access
resource "azurerm_role_assignment" "customer_key_vault_e6" {
  count               = var.key_vault_name != "" ? 1 : 0
  scope               = data.azurerm_key_vault.vault[0].id
  role_definition_id = azurerm_role_definition.e6data_key_vault_custom_role.0.role_definition_resource_id
  principal_id         = azurerm_user_assigned_identity.federated_identity.principal_id
}

resource "azurerm_role_assignment" "e6data_key_vault_e6" {
  count               = var.key_vault_name == "" ? 1 : 0
  scope               = azurerm_key_vault.e6data_vault[0].id
  role_definition_id  = azurerm_role_definition.e6data_key_vault_custom_role.0.role_definition_resource_id
  principal_id        = azurerm_user_assigned_identity.federated_identity.principal_id
}

# service principal role assignment to provide read and write access to the e6data managed storage account
resource "azurerm_role_assignment" "e6data_app_blob_role" {
  scope                = azurerm_storage_account.e6data_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.federated_identity.principal_id

  depends_on = [ azurerm_user_assigned_identity.federated_identity ]
}

# custom role definition to the service principal to get the aks credentials
resource "azurerm_role_definition" "e6data_aks_custom_role" {
  name        = "e6data aks custom role ${var.workspace_name} ${random_string.random.result}"
  description = "Custom role to list the aks cluster credential"
  scope       = data.azurerm_resource_group.aks_resource_group.id
  assignable_scopes = [
    data.azurerm_resource_group.aks_resource_group.id
  ]
  permissions {
    actions = [
      "Microsoft.ContainerService/managedClusters/listClusterUserCredential/action",
      "Microsoft.ContainerService/managedClusters/read"
    ]
    not_actions = []
  }
}

resource "azurerm_role_definition" "e6data_endpoint_custom_role" {
  name        = "e6data aks custom role ${var.workspace_name} ${random_string.random.result}2"
  description = "Custom role to read the lb and pip"
  scope       = module.aks_e6data.aks_managed_rg_id
  assignable_scopes = [
    module.aks_e6data.aks_managed_rg_id
  ]
  permissions {
    actions = [
      "Microsoft.Network/loadBalancers/read",
      "Microsoft.Network/publicIPAddresses/read",
      "Microsoft.Network/networkInterfaces/delete",
      "Microsoft.Network/networkInterfaces/read"
    ]
    not_actions = []
  }
}

# custom role assigment to the service principal to get the aks credentials
resource "azurerm_role_assignment" "e6data_aks_custom_role_assignment" {
  scope                = module.aks_e6data.cluster_id
  role_definition_id   = azurerm_role_definition.e6data_aks_custom_role.role_definition_resource_id
  principal_id         = azurerm_user_assigned_identity.federated_identity.principal_id

  depends_on = [ azurerm_role_definition.e6data_aks_custom_role, azurerm_user_assigned_identity.federated_identity ]

}

# custom role assigment to the service principal to get the load balancer and public ip credentials
resource "azurerm_role_assignment" "e6data_lb_custom_role_assignment" {
  scope                = module.aks_e6data.aks_managed_rg_id
  role_definition_id   = azurerm_role_definition.e6data_endpoint_custom_role.role_definition_resource_id
  principal_id         = azurerm_user_assigned_identity.federated_identity.principal_id

  depends_on = [azurerm_role_definition.e6data_endpoint_custom_role, azurerm_user_assigned_identity.federated_identity]
}