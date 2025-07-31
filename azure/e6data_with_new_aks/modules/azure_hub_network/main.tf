# Create Hub VNet
resource "azurerm_virtual_network" "hub" {
  name                = "${var.prefix}-hub-vnet"
  address_space       = var.hub_cidr_block
  location            = var.region
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Create subnet for Azure Firewall (must be named AzureFirewallSubnet)
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_virtual_network.hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.hub_cidr_block[0], 8, 0)]  # /24 subnet
}

# Create public IP for Azure Firewall (required for firewall to work)
resource "azurerm_public_ip" "firewall" {
  name                = "${var.prefix}-firewall-pip"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Create Azure Firewall
resource "azurerm_firewall" "main" {
  name                = "${var.prefix}-firewall"
  location            = var.region
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
}