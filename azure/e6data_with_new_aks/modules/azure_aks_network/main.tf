resource "azurerm_virtual_network" "vnet" {
  name                = "${var.env}-network"
  address_space       = var.cidr_block
  location            = var.region
  resource_group_name = var.resource_group_name
}

# Create AKS subnet to be used by nodes and pods
resource "azurerm_subnet" "aks" {
  name                 = format("%s-subnet-%s", var.env, "aks")
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], ceil(log(4, 2)), 0)]
}

# Create AKS subnet to be used by nodes and pods
# resource "azurerm_subnet" "ondemand" {
#   name                 = format("%s-subnet-%s", var.env, "aks")
#   resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0],ceil(log(4, 2)),2 )]
# }

# Create Virtual Node (ACI) subnet
resource "azurerm_subnet" "aci" {
  name                 = format("%s-subnet-%s", var.env, "aci")
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], ceil(log(4, 2)), 1)]

  # Designate subnet to be used by ACI
  delegation {
    name = "aci-delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
