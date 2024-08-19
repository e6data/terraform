# General configuration
prefix                          = "<prefix>"                       # Prefix for resources
region                          = "<region>"                       # Azure region
workspace_name                  = "<workspace_name>"               # Name of the e6data workspace to be created

# AKS cluster details
subscription_id                 = "<subscription_id>"              # Subscription ID of Azure subscription
aks_resource_group_name         = "<aks_resource_group_name>"      # Resource group name for AKS cluster
aks_cluster_name                = "<aks_cluster_name>"             # AKS cluster name
kube_version                    = "1.30"                           # Kubernetes version
kubernetes_namespace            = "<kubernetes_namespace>"         # Namespace to deploy e6data workspace
private_cluster_enabled         = "false"                          # Private cluster enabled (true/false)

# Networking
cidr_block                      = ["10.220.0.0/16"]                # CIDR block for the VNet

# Node pool configuration
nodepool_instance_family        = ["D", "F"]                       # Instance families for node pools
nodepool_instance_arch          = ["arm64"]                        # Instance architecture for node pools
priority                        = ["spot"]                         # VM priority (Regular or Spot)

# Data storage configuration
data_storage_account_name       = "<data_storage_account_name>"    # Storage account name
data_resource_group_name        = "<data_resource_group_name>"     # Resource group for storage account
list_of_containers              = ["*"]                            # Containers to access in storage account

# Helm chart version
helm_chart_version              = "2.0.9"                          # Helm chart version for e6data workspace

# Cost allocation tags
cost_tags = {
  App = "e6data"
}

# Default Node pool variables
default_node_pool_vm_size       = "standard_d2_v5"                   # VM size for the default node pool
default_node_pool_node_count    = 3                                # Number of nodes in the default node pool
default_node_pool_name          = "default"                        # Name of the default node pool

# Identity Pool Variables
identity_pool_id                = "<identity_pool_id>"             # The identity pool ID available in the e6data console after clicking on the "Create Workspace" button and selecting AZURE
identity_id                     = "<identity_id>"                  # The identity ID available in the e6data console, used for authentication and authorization in the workspace

# Karpenter Variables
karpenter_namespace             = "kube-system"                    # Namespace for Karpenter deployment
karpenter_service_account_name  = "karpenter"                      # Service account name for Karpenter
karpenter_release_version       = "0.6.0"                          # Karpenter release version

# Key Vault Configuration
key_vault_name                  = ""                               # Please provide the Key Vault name in which the certificate for the domain is present. If left blank, a new Key Vault will be created in the AKS resource group.
key_vault_rg_name               = ""                               # The resource group for the specified Key Vault. If left blank, it will default to the AKS resource group.

# Nginx Ingress Controller Configuration
nginx_ingress_controller_namespace = "kube-system"                # Namespace where the Nginx Ingress Controller will be deployed
nginx_ingress_controller_version   = "4.7.1"                      # Version of the Nginx Ingress Controller to be installed
