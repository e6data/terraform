output "vpc_id" {
  description = "The vpc ID"
  value       = azurerm_virtual_network.vnet.id
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
  value       = azurerm_virtual_network.vnet.guid
}

output "alb_subnet_id" {
  description = "The subnet ID for ALB (Application Gateway for Containers)"
  value       = var.create_alb_subnet ? azurerm_subnet.alb[0].id : null
}

output "alb_subnet_name" {
  description = "The subnet name for ALB (Application Gateway for Containers)"
  value       = var.create_alb_subnet ? azurerm_subnet.alb[0].name : null
}

output "alb_internal_subnet_id" {
  description = "The subnet ID for internal ALB (Application Gateway for Containers)"
  value       = var.create_alb_internal_subnet ? azurerm_subnet.alb_internal[0].id : null
}

output "alb_internal_subnet_name" {
  description = "The subnet name for internal ALB (Application Gateway for Containers)"
  value       = var.create_alb_internal_subnet ? azurerm_subnet.alb_internal[0].name : null
}

# output "ondemand_subnet_id" {
#   description = "The subnet ID for ondemand"
#   value = azurerm_subnet.ondemand.name
# }
