# Create a node pool in the AKS cluster
module "nodepool" {
  source = "./modules/aks_nodepool"

  nodepool_name       = var.workspace_name
  aks_cluster_name    = module.aks_engine.cluster_name
  vm_size             = var.vm_size
  kube_version        = module.aks_engine.kube_version
  enable_auto_scaling = var.enable_auto_scaling
  min_number_of_nodes = var.min_size
  max_number_of_nodes = var.max_size
  vnet_subnet_id      = module.network.aks_subnet_id
  zones               = var.zones
  priority            = var.priority
  spot_max_price      = var.spot_max_price
  eviction_policy     = var.spot_eviction_policy
  tags = merge(
    {
      namespace = var.kubernetes_namespace
    },
    var.cost_tags
  )
  depends_on = [module.network]

}

locals {
  helm_values_file = yamlencode({
    cloud = {
      type               = "AZURE"
      oidc_value         = azurerm_user_assigned_identity.e6data_identity.client_id
      control_plane_user = [data.azuread_service_principal.e6data_service_principal.object_id]
    }
  })
}

# Create user-assigned identity, which is used by the engine to access data buckets.
resource "azurerm_user_assigned_identity" "e6data_identity" {
  location            = data.azurerm_resource_group.aks_resource_group.location
  name                = "${var.workspace_name}-identity"
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  tags                = var.cost_tags
}

# This resource block creates a federated identity credential, which will be used for authentication and authorization from the AKS.
resource "azurerm_federated_identity_credential" "e6data_federated_credential" {
  name                = "${var.workspace_name}-federated-credential"
  audience            = ["api://AzureADTokenExchange"]
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  issuer              = module.aks_engine.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.e6data_identity.id
  subject             = "system:serviceaccount:${var.kubernetes_namespace}:${var.workspace_name}"
}

resource "azurerm_role_assignment" "e6data_engine_write_role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.e6data_identity.principal_id
}

resource "helm_release" "workspace_deployment" {
  provider = helm.engine

  name             = var.workspace_name
  repository       = "https://e6x-labs.github.io/helm-charts/"
  chart            = "workspace"
  namespace        = var.kubernetes_namespace
  create_namespace = true
  version          = var.helm_chart_version
  timeout          = 600

  values = [local.helm_values_file]

  lifecycle {
    ignore_changes = [values]
  }
  depends_on = [module.aks_engine, module.nodepool, kubernetes_namespace.engine_namespace]
}