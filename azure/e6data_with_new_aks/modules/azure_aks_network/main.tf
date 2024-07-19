resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-network"
  address_space       = var.cidr_block
  location            = var.region
  resource_group_name = var.resource_group_name
}

# Create AKS subnet to be used by nodes and pods
resource "azurerm_subnet" "aks" {
  name                 = format("%s-subnet-%s", "${var.prefix}", "aks")
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], ceil(log(4, 2)), 0)]
}

# Create Virtual Node (ACI) subnet
resource "azurerm_subnet" "aci" {
  name                 = format("%s-subnet-%s", "${var.prefix}", "aci")
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

resource "azurerm_private_dns_zone" "aks_private_dns_zone" {
  count                  = var.private_cluster_enabled ? 1 : 0
  name                = "privatelink.${var.region}.azmk8s.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "aks_dns_link" {
  count                  = var.private_cluster_enabled ? 1 : 0
  name                  = "${var.prefix}-aks-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.aks_private_dns_zone.0.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

