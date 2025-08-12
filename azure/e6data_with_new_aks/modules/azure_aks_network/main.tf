# Use existing VNet
data "azurerm_virtual_network" "vnet" {
  name                = var.existing_vnet_name
  resource_group_name = var.existing_vnet_resource_group_name
}

# Create AKS subnet to be used by nodes and pods
resource "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.existing_vnet_resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.aks_subnet_address_prefixes
  service_endpoints    = ["Microsoft.Storage"]
  
  # Enable private subnet (no default outbound access)
  default_outbound_access_enabled = false
}

# Create Virtual Node (ACI) subnet
resource "azurerm_subnet" "aci" {
  name                 = var.aci_subnet_name
  resource_group_name  = var.existing_vnet_resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.aci_subnet_address_prefixes
  
  # Enable private subnet (no default outbound access)
  default_outbound_access_enabled = false

  # Designate subnet to be used by ACI
  delegation {
    name = "aci-delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}