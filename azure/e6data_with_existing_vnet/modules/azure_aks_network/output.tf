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