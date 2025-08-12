output "vpc_id" {
  description = "The vpc ID"
  value       = data.azurerm_virtual_network.vnet.id
}

output "aks_subnet_id" {
  description = "The subnet ID for aks"
  value       = azurerm_subnet.aks.id
}

output "aci_subnet_id" {
  description = "The subnet name for aci"
  value       = azurerm_subnet.aci.id
}

output "aci_subnet_name" {
  description = "The subnet ID for aci"
  value       = azurerm_subnet.aci.name
}

output "vnet_guid" {
  description = "The guid for vnet"
  value       = data.azurerm_virtual_network.vnet.guid
}

output "vnet_id" {
  description = "The VNet ID"
  value       = data.azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The VNet name"
  value       = data.azurerm_virtual_network.vnet.name
}

# output "ondemand_subnet_id" {
#   description = "The subnet ID for ondemand"
#   value = azurerm_subnet.ondemand.name
# }
