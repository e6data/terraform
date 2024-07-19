resource "azurerm_key_vault" "e6data_vault" {
  count               = var.key_vault_name != "" ? 0 : 1
  name                = "${var.prefix}-vault"
  resource_group_name = var.aks_resource_group_name
  location            = var.region
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  tags = var.cost_tags
}

data "azurerm_key_vault" "vault" {
  count               = var.key_vault_name != "" ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg_name
}

resource "azurerm_role_assignment" "customer_key_vault" {
  count               = var.key_vault_name != "" ? 1 : 0
  scope               = data.azurerm_key_vault.vault[0].id
  role_definition_name = "Key Vault Certificate User"
  principal_id        = module.aks_e6data.kubelet_identity
}

resource "azurerm_role_assignment" "e6data_key_vault" {
  count               = var.key_vault_name == "" ? 1 : 0
  scope               = azurerm_key_vault.e6data_vault[0].id
  role_definition_name = "Key Vault Certificate User"
  principal_id        = module.aks_e6data.kubelet_identity
}

resource "helm_release" "akv2k8s" {
  provider = helm.e6data

  name       = "akv2k8s"
  chart      = "akv2k8s"
  repository = "http://charts.spvapi.no"
  namespace  = "kube-system"
}
