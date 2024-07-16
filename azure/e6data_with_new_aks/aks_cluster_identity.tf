resource "azurerm_role_assignment" "aks_subnet" {
  scope                = module.network.aks_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks_e6data.aks_principal_id

  depends_on = [ module.aks_e6data, module.network ]
}