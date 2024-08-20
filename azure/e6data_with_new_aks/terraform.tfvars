# General configuration
prefix                          = "e6"                             # Prefix for resources
region                          = "eastus"                          # Azure region
workspace_name                  = "e6data-workspace"                # Name of the e6data workspace to be created

# AKS cluster details
subscription_id                 = "12345678-1234-1234-1234-1234567890ab"  # Subscription ID of Azure subscription
aks_resource_group_name         = "e6data-aks-rg"                   # Resource group name for AKS cluster
aks_cluster_name                = "e6data-aks-cluster"              # AKS cluster name
kube_version                    = "1.30"                            # Kubernetes version
kubernetes_namespace            = "e6data"                          # Namespace to deploy e6data workspace
private_cluster_enabled         = "false"                           # Private cluster enabled (true/false)

# Networking
cidr_block                      = ["10.220.0.0/16"]                 # CIDR block for the VNet

# Node pool configuration
nodepool_instance_family        = ["D", "F"]                        # Instance families for node pools
nodepool_instance_arch          = ["arm64"]                         # Instance architecture for node pools
priority                        = ["spot"]                          # VM priority (Regular or Spot)

# Data storage configuration
data_storage_account_name       = "e6datastorage"                   # Storage account name
data_resource_group_name        = "e6data-storage-rg"               # Resource group for storage account
list_of_containers              = ["data-container", "logs-container"]  # Containers to access in storage account

# Helm chart version
helm_chart_version              = "2.0.9"                           # Helm chart version for e6data workspace

# Cost allocation tags
cost_tags = {                                                       # Tags used for cost allocation and management. Helps in tracking and optimizing resource costs.
  App = "e6data"
}

# Default Node pool variables
default_node_pool_vm_size       = "standard_d2_v5"                  # VM size for the default node pool
default_node_pool_node_count    = 3                                 # Number of nodes in the default node pool
default_node_pool_name          = "default"                         # Name of the default node pool

# Identity Pool Variables
identity_pool_id                = "identity-pool-12345"             # The identity pool ID available in the e6data console
identity_id                     = "identity-67890"                  # The identity ID available in the e6data console

# Karpenter Variables
karpenter_namespace             = "kube-system"                     # Namespace for Karpenter deployment
karpenter_service_account_name  = "karpenter"                       # Service account name for Karpenter
karpenter_release_version       = "0.6.0"                           # Karpenter release version

# Key Vault Configuration
key_vault_name                  = "e6data-keyvault"                 # Name of the Key Vault with the certificate for the domain
key_vault_rg_name               = "e6data-keyvault-rg"              # The resource group for the specified Key Vault

# Nginx Ingress Controller Configuration
nginx_ingress_controller_namespace = "kube-system"                 # Namespace where the Nginx Ingress Controller will be deployed
nginx_ingress_controller_version   = "4.7.1"                       # Version of the Nginx Ingress Controller to be installed
