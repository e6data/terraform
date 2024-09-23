# Create Azure container to store the blobs
resource azurerm_storage_container "e6data_blobs" {
  name                  = "e6data${var.container_name}"
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}