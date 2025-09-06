resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-network"
  address_space       = var.cidr_block
  location            = var.region
  resource_group_name = var.resource_group_name
}

# Create AKS subnet to be used by nodes and pods (larger subnet for more IPs)
resource "azurerm_subnet" "aks" {
  name                 = format("%s-subnet-%s", "${var.prefix}", "aks")
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 2, 0)] # /18 - 16,384 IPs
  service_endpoints    = ["Microsoft.Storage"]
}

# Create Virtual Node (ACI) subnet (smaller subnet with fewer IPs)
resource "azurerm_subnet" "aci" {
  name                 = format("%s-subnet-%s", "${var.prefix}", "aci")
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 6, 16)] # /22 - 1,024 IPs starting from 10.220.128.0

  # Designate subnet to be used by ACI
  delegation {
    name = "aci-delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# Create Application Gateway for Containers (ALB) subnet
resource "azurerm_subnet" "alb" {
  count = var.create_alb_subnet ? 1 : 0
  
  name                 = format("%s-subnet-%s", "${var.prefix}", "alb")
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 8, 80)] # /24 - 256 IPs starting from 10.220.80.0

  # Delegate subnet to be used by Application Gateway for Containers
  delegation {
    name = "alb-delegation"

    service_delegation {
      name    = "Microsoft.ServiceNetworking/trafficControllers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Create private subnet for internal Application Gateway for Containers
resource "azurerm_subnet" "alb_internal" {
  count = var.create_alb_internal_subnet ? 1 : 0
  
  name                 = format("%s-subnet-%s", "${var.prefix}", "alb-internal")
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 8, 81)] # /24 - 256 IPs starting from 10.220.81.0

  # Delegate subnet to be used by Application Gateway for Containers (internal)
  delegation {
    name = "alb-internal-delegation"

    service_delegation {
      name    = "Microsoft.ServiceNetworking/trafficControllers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
