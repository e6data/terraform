# General configuration
prefix                          = "e6data"                       # Prefix for resources
region                          = "eastus"                       # Azure region
workspace_name                  = "existing"                  # Name of the e6data workspace to be created

# AKS cluster details
subscription_id                 = "244ad77a-91e4-4a8e-9193-835d79ac55e2"  # Subscription ID of AZURE subscription
aks_resource_group_name         = "jultuesday"                    # Resource group name for AKS cluster
aks_cluster_name                = "e6data-poc"                         # AKS cluster name
kubernetes_namespace            = "existing"                      # Namespace to deploy e6data workspace

# Karpenter Node pool configuration
nodepool_instance_family        = ["D", "F"]                    # Instance families for node pools
nodepool_instance_arch          = ["arm64"]
priority                        = ["spot"]                      # VM priority (Regular or Spot)

# Identity Pool Variables
identity_pool_id                = "<identity_pool_id>"             # The identity pool ID available in the e6data console after clicking on the "Create Workspace" button and selecting AZURE
identity_id                     = "<identity_id>"                  # The identity ID available in the e6data console, used for authentication and authorization in the workspace

# Data storage configuration
data_storage_account_name       = "e6dataengine"                  # Storage account name
data_resource_group_name        = "e6data-common"                     # Resource group for storage account
list_of_containers              = ["*"]                         # Containers to access in storage account

# e6data Helm chart version
helm_chart_version              = "2.0.8"                       # Helm chart version for e6data workspace

# Cost allocation tags
cost_tags = {
  App = "e6data"
}

# Default Node pool variables
default_node_pool_vm_size       = "standard_d2_v5"
default_node_pool_node_count    = 2
default_node_pool_name          = "default"

# Karpenter Variables
karpenter_namespace             = "kube-system"                 # Namespace for Karpenter deployment
karpenter_service_account_name  = "karpenter"                   # Service account name for Karpenter
karpenter_release_version       = "0.5.0"                       # Karpenter release version

key_vault_name = "hsgateway"                                    # Key vault in which the ssl certificate is present for the endpoints,A new key vault will be created if this is empty
key_vault_rg_name = "endpoint"

nginx_ingress_controller_helm_version = "4.7.1"
nginx_ingress_controller_namespace = "kube-system"