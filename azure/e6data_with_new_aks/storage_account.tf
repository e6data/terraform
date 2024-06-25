# Create Azure Storage Account

resource azurerm_storage_account "e6data_storage_account" {
  name                     = "e6data${var.workspace_name}"
  resource_group_name      = data.azurerm_resource_group.aks_resource_group.name
  location                 = data.azurerm_resource_group.aks_resource_group.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.default_tags
}

# Create containers
module "containers" {
  source               = "./modules/azure_containers"
  storage_account_name = azurerm_storage_account.e6data_storage_account.name
  container_name       = "${var.prefix}-${var.workspace_name}-${random_string.random.result}"
}

