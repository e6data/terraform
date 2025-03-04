#retrieves information about the primary Azure subscription.
data "azurerm_subscription" "primary" {
  subscription_id = var.subscription_id
}

#retrieves the current Azure Active Directory (Azure AD) client configuration.
data "azuread_client_config" "current" {}

#retrieves the current Azure client configuration.
data "azurerm_client_config" "current" {}

# Retrieve information about the resource group of the aks
data "azurerm_resource_group" "aks_resource_group" {
  name = var.aks_resource_group_name
}

data "azurerm_storage_account" "data_storage_account" {
  name                = var.data_storage_account_name
  resource_group_name = var.data_resource_group_name
}

locals {

  e6data_nodepool_name  = "e6data-nodepool-${local.short_workspace_name}-${random_string.random.result}"
  e6data_nodeclass_name = "e6data-nodeclass-${local.short_workspace_name}-${random_string.random.result}"

  short_workspace_name      = substr(var.workspace_name, 0, 4)
  e6data_workspace_name     = "e6data-${local.short_workspace_name}"
  workspace_role_name       = replace(var.workspace_name, "-", "_")
  workspace_write_role_name = "e6data_${local.workspace_role_name}_write"
  workspace_read_role_name  = "e6data_${local.workspace_role_name}_read"
  cluster_viewer_role_name  = "e6data_${local.workspace_role_name}_cluster_viewer"
  workload_role_name        = "e6data_${local.workspace_role_name}_workload_identity_user"
  target_pool_role_name     = "e6data_${local.workspace_role_name}_targetpool_read"
  security_policy_role_name = "e6data_${local.workspace_role_name}_security_policy"
  global_address_role_name  = "e6data_${local.workspace_role_name}_globaladdress_policy"

  node_identities = ""
  bootstrap_token = join(".",[base64decode(data.kubernetes_resources.bootstrap.objects.0.data.token-id),base64decode(data.kubernetes_resources.bootstrap.objects.0.data.token-secret)])

  helm_values_file = yamlencode({
    cloud = {
      type               = "AZURE"
      oidc_value         = azurerm_user_assigned_identity.e6data_identity.client_id
      control_plane_user = [azurerm_user_assigned_identity.federated_identity.principal_id]
      debug_namespaces   = var.debug_namespaces
    }
  })

  default_tags = {
    app          = "e6data"
  }

  all_containers = data.azurerm_storage_account.data_storage_account.id

  blob_storage_container_path = "https://${azurerm_storage_account.e6data_storage_account.name}.blob.core.windows.net/${module.containers.container_name}"

}

resource "random_string" "random" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}