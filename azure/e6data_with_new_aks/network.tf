# Hub network with Azure Firewall
module "hub_network" {
  source              = "./modules/azure_hub_network"
  region              = var.region
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  prefix              = var.prefix
  hub_cidr_block      = ["10.1.0.0/16"]  # Hub VNet CIDR
  
  # Peering configuration
  spoke_vnet_id             = module.network.vnet_id
  spoke_vnet_name           = module.network.vnet_name
  spoke_resource_group_name = data.azurerm_resource_group.aks_resource_group.name
}

# Spoke network for AKS - using existing VNet and creating subnets
module "network" {
  source              = "./modules/azure_aks_network"
  cidr_block          = var.cidr_block
  region              = var.region
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  prefix              = var.prefix
  
  # Existing network resources
  existing_vnet_name                = var.existing_vnet_name
  existing_vnet_resource_group_name = var.existing_vnet_resource_group_name
  
  # Subnet configuration
  aks_subnet_name             = var.aks_subnet_name
  aks_subnet_address_prefixes = var.aks_subnet_address_prefixes
  aci_subnet_name             = var.aci_subnet_name
  aci_subnet_address_prefixes = var.aci_subnet_address_prefixes
  
  # Pass firewall IP for route table configuration
  firewall_private_ip = module.hub_network.firewall_private_ip
}