module "network" {
  source              = "./modules/azure_aks_network"
  cidr_block          = var.cidr_block
  region              = var.region
  resource_group_name = var.resource_group_name
  prefix              = var.prefix
}