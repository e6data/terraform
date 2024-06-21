data "azurerm_storage_account" "e6data_storage_account" {
  name                = var.data_storage_account
  resource_group_name = var.data_resource_group
}

# Create containers
module "containers" {
  for_each             = var.container_names
  source               = "./modules/azure_containers"
  storage_account_name = data.azurerm_storage_account.e6data_storage_account.name
  container_name       = "${var.env}-${each.key}"
}