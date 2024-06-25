data "azurerm_storage_account" "e6data_storage_account" {
  name                = var.data_storage_account
  resource_group_name = var.data_resource_group
}

# Create containers
module "containers" {
  source               = "./modules/azure_containers"
  storage_account_name = data.azurerm_storage_account.e6data_storage_account.name
  container_name       = "${var.prefix}-${var.workspace_name}-${random_string.random.result}"
}