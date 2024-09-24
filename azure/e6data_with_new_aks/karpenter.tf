# Create user-assigned identity, which is used by the karpenter.
resource "azurerm_user_assigned_identity" "karpenter" {
  location            = data.azurerm_resource_group.aks_resource_group.location
  name                = "${var.workspace_name}-karpenter-identity-${random_string.random.result}"
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  tags                = var.cost_tags
}

# This resource block creates a federated identity credential, which will be used for authentication and authorization from the AKS.
resource "azurerm_federated_identity_credential" "karpenter_federated_credential" {
  name                = "${var.workspace_name}-karpenter-federated-credential-${random_string.random.result}"
  audience            = ["api://AzureADTokenExchange"]
  resource_group_name = data.azurerm_resource_group.aks_resource_group.name
  issuer              = module.aks_e6data.oidc_issuer_url
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
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.aks_resource_group.name}"
  role_definition_name = each.key
}

# role assignment to provide permission to karpenter
resource "azurerm_role_assignment" "karpenter_roles_rg" {
  for_each = toset([
    "Virtual Machine Contributor",
    "Network Contributor",
    "Managed Identity Operator"
  ])

  principal_id         = azurerm_user_assigned_identity.karpenter.principal_id
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${module.aks_e6data.aks_managed_rg_name}"
  role_definition_name = each.key
}

module "karpenter" {
  source                  = "./modules/karpenter"
  providers = {
    kubernetes = kubernetes.e6data
    helm       = helm.e6data
  }

  karpenter_version            = var.karpenter_release_version
  aks_cluster_name             = module.aks_e6data.cluster_name_short
  aks_cluster_endpoint         = module.aks_e6data.host
  node_identities              = local.node_identities
  subscription_id              = var.subscription_id
  location                     = var.region
  aks_subnet_id                = module.network.aks_subnet_id
  node_resource_group          = module.aks_e6data.aks_managed_rg_name
  karpenter_namespace          = var.karpenter_namespace
  karpenter_service_account_name = var.karpenter_service_account_name
  karpenter_managed_identity_client_id = azurerm_user_assigned_identity.karpenter.client_id
  public_ssh_key               = module.aks_e6data.generated_cluster_public_ssh_key
  bootstrap_token              = local.bootstrap_token

  depends_on = [module.network]
}

# Data source to fetch and template Karpenter provisioner manifests
data "kubectl_path_documents" "provisioner_manifests" {
  pattern = "./karpenter-provisioner-manifests/*.yaml"
  vars = {
    workspace_name           = var.workspace_name
    cluster_name             = module.aks_e6data.cluster_name
    sku_family               = jsonencode(var.nodepool_instance_family)
    nodeclass_name           = local.e6data_nodeclass_name
    nodepool_name            = local.e6data_nodepool_name
    arch                     = jsonencode(var.nodepool_instance_arch)
    
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
  depends_on = [ module.aks_e6data]
}

resource "kubectl_manifest" "provisioners" {
  count     = 2
  yaml_body = values(data.kubectl_path_documents.provisioner_manifests.manifests)[count.index]

  depends_on = [module.karpenter]
}


# The cronjob will update the bootstarp token in the karpenter env variable whenever its rotated
resource "kubernetes_cron_job_v1" "update_karpenter_token" {
  provider = kubernetes.e6data
  metadata {
    name      = "update-karpenter-tokena"
    namespace = "kube-system"
  }

  spec {
    schedule = "* * * * *"
    job_template {
      metadata {
        name = "e6data-update-karpenter-token"
        labels = {
          app = "e6data"
        }
      }
      spec {
        template {
          metadata {
            labels = {
              app = "e6data"
            }
          }
          spec {
            service_account_name = "karpenter-token-update"
            container {
              name  = "update-karpenter"
              image = "bitnami/kubectl:latest"
              command = ["/bin/sh", "-c"]
              args = [
                <<-EOF
                  TOKEN_SECRET_NAME=$$(kubectl get secret -n kube-system --field-selector type=bootstrap.kubernetes.io/token -o jsonpath='{.items[0].metadata.name}')
                  if [ -z "$$TOKEN_SECRET_NAME" ]; then
                    echo "No bootstrap token found, exiting."
                    exit 1
                  fi
                  TOKEN_ID=$$(kubectl get secret $$TOKEN_SECRET_NAME -n kube-system -o jsonpath='{.data.token-id}' | base64 --decode)
                  TOKEN_SECRET=$$(kubectl get secret $$TOKEN_SECRET_NAME -n kube-system -o jsonpath='{.data.token-secret}' | base64 --decode)
                  NEW_TOKEN="$${TOKEN_ID}.$${TOKEN_SECRET}"
                  CURRENT_TOKEN=$$(kubectl get deployment karpenter -n kube-system -o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="KUBELET_BOOTSTRAP_TOKEN")].value}')
                  if [ "$$NEW_TOKEN" != "$$CURRENT_TOKEN" ]; then
                    kubectl set env deployment karpenter KUBELET_BOOTSTRAP_TOKEN=$$NEW_TOKEN -n kube-system
                    kubectl rollout restart deployment karpenter -n kube-system
                  else
                    echo "Token has not changed, no update needed."
                  fi
                EOF
              ]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}
