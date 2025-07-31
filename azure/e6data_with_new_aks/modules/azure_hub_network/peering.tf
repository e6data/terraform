# Variables needed for peering
variable "spoke_vnet_id" {
  description = "ID of the spoke VNet to peer with"
  type        = string
}

variable "spoke_vnet_name" {
  description = "Name of the spoke VNet"
  type        = string
}

variable "spoke_resource_group_name" {
  description = "Resource group of the spoke VNet"
  type        = string
}

# Peering from Hub to Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "${var.prefix}-hub-to-spoke"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = var.spoke_vnet_id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

# Peering from Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "${var.prefix}-spoke-to-hub"
  resource_group_name       = var.spoke_resource_group_name
  virtual_network_name      = var.spoke_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}