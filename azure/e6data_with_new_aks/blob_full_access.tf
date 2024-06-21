# Create an Azure AD application
resource "azuread_application" "e6data_blob_full_access" {
  display_name     = "blob_full_access_${var.cluster_name}"
  owners           = [data.azuread_client_config.current.object_id]
  sign_in_audience = "AzureADMyOrg"
}

# Create an Azure AD application password
resource "azuread_application_password" "blob_full_access_secret" {
  application_object_id             = azuread_application.e6data_blob_full_access.id
  end_date_relative                 = var.e6data_blob_full_access_secret_expiration_time
}

# Create an Azure AD service principal
resource "azuread_service_principal" "blob_service_principal" {
  application_id = azuread_application.e6data_blob_full_access.application_id
  owners       = [data.azuread_client_config.current.object_id]
}

# service principal role assignment to provide read and write access to the e6data managed storage account
resource "azurerm_role_assignment" "e6data_blob_full_access_blob_role" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.blob_service_principal.object_id
}

resource "kubernetes_secret" "azuread_app_secret" {
  provider = kubernetes.engine

  for_each = var.engine_namespaces
  metadata {
    name = "blobfullaccess"
    namespace = each.key
  }

  data = {
    blob_access_client_id = azuread_application.e6data_blob_full_access.application_id
    blob_access_tenant_id = data.azurerm_client_config.current.tenant_id
    blob_access_secret = azuread_application_password.blob_full_access_secret.value
  }
}