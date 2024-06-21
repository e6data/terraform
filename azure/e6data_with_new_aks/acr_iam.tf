
data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.acr_rg
}

# add the role to the identity the kubernetes cluster was assigned
resource "azurerm_role_assignment" "role_to_acr" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_engine.kubelet_identity
}
