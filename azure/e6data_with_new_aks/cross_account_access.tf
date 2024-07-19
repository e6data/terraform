# Create an Azure AD application
resource "azuread_application" "e6data_app" {
  display_name     = "${var.workspace_name}-app-${random_string.random.result}"
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMultipleOrgs"
}

# Create an Azure AD application password
resource "azuread_application_password" "e6data_secret" {
  application_id                    = azuread_application.e6data_app.id
  end_date_relative                 = var.e6data_app_secret_expiration_time
}

# Create an Azure AD service principal
resource "azuread_service_principal" "e6data_service_principal" {
  client_id    = azuread_application.e6data_app.application_id
  owners       = [data.azuread_client_config.current.object_id]
}

# service principal role assignment to provide read and write access to the e6data managed storage account
resource "azurerm_role_assignment" "e6data_app_blob_role" {
  scope                = azurerm_storage_account.e6data_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.e6data_service_principal.object_id
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
  name        = "e6data aks custom role ${var.workspace_name} ${random_string.random.result}"
  description = "Custom role to read the lb and pip"
  scope       = module.aks_e6data.aks_managed_rg_id
  assignable_scopes = [
    module.aks_e6data.aks_managed_rg_id
  ]
  permissions {
    actions = [
      "Microsoft.Network/loadBalancers/read",
      "Microsoft.Network/publicIPAddresses/read"
    ]
    not_actions = []
  }
}

# custom role assigment to the service principal to get the aks credentials
resource "azurerm_role_assignment" "e6data_aks_custom_role_assignment" {
  scope                = module.aks_e6data.cluster_name
  role_definition_id   = azurerm_role_definition.e6data_aks_custom_role.role_definition_resource_id
  principal_id         = azuread_service_principal.e6data_service_principal.object_id

  depends_on = [ azurerm_role_definition.e6data_aks_custom_role ]
}

# custom role assigment to the service principal to get the load balancer and public ip credentials
resource "azurerm_role_assignment" "e6data_lb_custom_role_assignment" {
  scope                = module.aks_e6data.aks_managed_rg_id
  role_definition_id   = azurerm_role_definition.e6data_endpoint_custom_role.role_definition_resource_id
  principal_id         = azuread_service_principal.e6data_service_principal.object_id

  depends_on = [azurerm_role_definition.e6data_endpoint_custom_role]
}