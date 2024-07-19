# Create user-assigned identity, which is used by the engine to access data buckets.
resource "azurerm_user_assigned_identity" "e6data_identity" {
  location            = data.azurerm_resource_group.aks_resource_group.location
  name                = "${var.workspace_name}-identity-${random_string.random.result}"
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  tags                = var.cost_tags
}

# This resource block creates a federated if edentity credential, which will be used for authentication and authorization from the AKS.
resource "azurerm_federated_identity_credential" "e6data_federated_credential" {
  name                = "${var.workspace_name}-federated-credential-${random_string.random.result}"
  audience            = ["api://AzureADTokenExchange"]
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  issuer              = module.aks_e6data.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.e6data_identity.id
  subject             = "system:serviceaccount:${var.kubernetes_namespace}:${var.workspace_name}"
}

# role assignment to provide permission to service principal to read the data in the containers
resource "azurerm_role_assignment" "e6data_engine_read_role" {
  for_each              = contains(var.list_of_containers, "*") ? toset(["wildcard"]) : toset(var.list_of_containers)
  scope                 = contains(var.list_of_containers, "*") ? local.all_containers : "${data.azurerm_storage_account.data_storage_account.id}/blobServices/default/containers/${each.value}"
  role_definition_name  = "Storage Blob Data Reader"
  principal_id          = azurerm_user_assigned_identity.e6data_identity.principal_id
}

# managed identity role assignment to provide read and write access to the e6data managed storage account
resource "azurerm_role_assignment" "e6data_engine_write_role" {
  scope                = azurerm_storage_account.e6data_storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.e6data_identity.principal_id
}
