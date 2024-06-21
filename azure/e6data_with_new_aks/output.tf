output "client_id" {
  sensitive = true
  value     = azuread_application.e6data_blob_full_access.application_id
}

output "tenant_id" {
  sensitive = true
  value     = data.azurerm_client_config.current.tenant_id
}

output "secret" {
  sensitive = true
  value     = azuread_application_password.blob_full_access_secret.value
}