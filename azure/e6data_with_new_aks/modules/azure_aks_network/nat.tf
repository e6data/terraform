resource "azurerm_nat_gateway" "nat" {
  name                    = "${var.prefix}-nat"
  location                = var.region
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 30

  tags                    = var.tags
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-PIP"
  location            = var.region
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "pip_associate" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.pip.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_subnet_assciate" {
  subnet_id      = azurerm_subnet.aks.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}