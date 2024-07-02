# Create user-assigned identity, which is used by the karpenter.
resource "azurerm_user_assigned_identity" "karpenter" {
  location            = data.azurerm_resource_group.aks_resource_group.location
  name                = "${var.workspace_name}-karpenter-identity"
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  tags                = local.default_tags
}

# This resource block creates a federated identity credential, which will be used for authentication and authorization from the AKS.
resource "azurerm_federated_identity_credential" "karpenter_federated_credential" {
  name                = "${var.workspace_name}-karpenter-federated-credential"
  audience            = ["api://AzureADTokenExchange"]
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  issuer              = data.azurerm_kubernetes_cluster.this.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.karpenter.id
  subject             = "system:serviceaccount:${var.karpenter_namespace}:${var.karpenter_service_account_name}"
}

# role assignment to provide permission to karpenter
resource "azurerm_role_assignment" "karpenter_roles" {
  for_each = toset([
    "Virtual Machine Contributor",
    "Network Contributor",
    "Managed Identity Operator"
  ])

  principal_id         = azurerm_user_assigned_identity.karpenter.principal_id
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${module.aks_e6data.node_resource_group}"
  role_definition_name = each.key
}

module "karpenter" {
  source                  = "./modules/karpenter"
  provider                 = helm.e6data
  
  depends_on = [module.network]
}


data "azurerm_availability_zones" "available" {
  location = var.region
}
# Data source to fetch and template Karpenter provisioner manifests
data "kubectl_path_documents" "provisioner_manifests" {
  pattern = "./karpenter-provisioner-manifests/*.yaml"
  vars = {
    workspace_name           = var.workspace_name
    available_zones          = jsonencode(data.azurerm_availability_zones.available.zones)
    cluster_name             = module.eks.cluster_name
    instance_family          = jsonencode(var.nodepool_instance_family)
    karpenter_node_role_name = aws_iam_role.karpenter_node_role.name
    volume_size              = var.eks_disk_size
    nodeclass_name           = local.e6data_nodeclass_name
    nodepool_name            = local.e6data_nodepool_name
    tags = jsonencode(
      merge(
        var.cost_tags,
        {
          "Name" = local.e6data_workspace_name
        }
      )
    )
    nodepool_cpu_limits = var.nodepool_cpu_limits
  }
  depends_on = [data.aws_availability_zones.available, aws_iam_role.karpenter_node_role, module.eks]
}

resource "kubectl_manifest" "provisioners" {
  count     = 2
  yaml_body = values(data.kubectl_path_documents.provisioner_manifests.manifests)[count.index]

  depends_on = [module.karpeneter_deployment]
}