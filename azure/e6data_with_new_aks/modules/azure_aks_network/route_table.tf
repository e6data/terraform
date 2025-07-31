resource "azurerm_route_table" "aks" {
  name                = "${var.prefix}-route-table"
  location            = var.region
  resource_group_name = var.resource_group_name

  # Route all traffic through Azure Firewall in hub network
  route {
    name                   = "default-to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.aks.id
}