module "network" {
  source              = "./modules/azure_aks_network"
  cidr_block          = var.cidr_block
  region              = var.region
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  prefix              = var.prefix
  
  # ALB subnet configuration
  create_alb_subnet        = var.agfc_enabled
  alb_subnet_prefix_length = var.agfc_subnet_prefix_length
  alb_subnet_cidr_offset   = var.agfc_subnet_cidr_offset
  
  # Internal ALB subnet configuration
  create_alb_internal_subnet        = var.agfc_internal_enabled
  alb_internal_subnet_prefix_length = var.agfc_internal_subnet_prefix_length
  alb_internal_subnet_cidr_offset   = var.agfc_internal_subnet_cidr_offset
}