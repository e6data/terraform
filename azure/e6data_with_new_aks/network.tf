module "network" {
  source              = "./modules/azure_aks_network"
  cidr_block          = var.cidr_block
  region              = var.region
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  prefix              = var.prefix
  tags                     = var.cost_tags
}