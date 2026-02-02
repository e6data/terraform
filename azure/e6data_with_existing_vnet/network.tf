module "network" {
  source              = "./modules/azure_aks_network"
  vnet_name           = var.vnet_name
  region              = var.region
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  prefix              = var.prefix
  aks_subnet_cidr     = var.aks_subnet_cidr
  aci_subnet_cidr     = var.aci_subnet_cidr

  # ALB subnet configuration
  create_alb_subnet    = var.agfc_enabled
  alb_subnet_cidr      = var.alb_subnet_cidr

  # Internal ALB subnet configuration
  create_alb_internal_subnet = var.agfc_internal_enabled
  alb_internal_subnet_cidr   = var.alb_internal_subnet_cidr
}