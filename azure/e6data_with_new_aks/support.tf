#retrieves information about the primary Azure subscription.
data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

#retrieves the current Azure Active Directory (Azure AD) client configuration.
data "azuread_client_config" "current" {}

#retrieves the current Azure client configuration.
data "azurerm_client_config" "current" {}

# Retrieve information about the resource group of the aks
data "azurerm_resource_group" "aks_resource_group" {
  name = var.resource_group_name
}

data "azuread_service_principal" "e6data_service_principal" {
  display_name = "AK-TEST"
}
