# General configuration
prefix                          = "e6data"                       # Prefix for resources
region                          = "eastus"                       # Azure region
workspace_name                  = "e6workspace"                  # Name of the e6data workspace to be created

# AKS cluster details
subscription_id                 = "abcdh100000-abcd-efgh-0000-000000000"  # Subscription ID of AZURE subscription
aks_resource_group_name         = "e6datarg"                    # Resource group name for AKS cluster
aks_cluster_name                = "poc"                         # AKS cluster name
kube_version                    = "1.28"                        # Kubernetes version
kubernetes_namespace            = "e6data"                      # Namespace to deploy e6data workspace
private_cluster_enabled         = "false"                       # Private cluster enabled (true/false)

# Networking
cidr_block                      = ["10.210.0.0/16"]             # CIDR block for the VNet

# Node pool configuration
nodepool_instance_family        = ["D", "F"]                    # Instance families for node pools
priority                        = ["spot"]                      # VM priority (Regular or Spot)

# Application secrets
e6data_app_secret_expiration_time = "2400h"                     # Expiration time for application secret

# Data storage configuration
data_storage_account_name       = "databucket"                  # Storage account name
data_resource_group_name        = "data-rg"                     # Resource group for storage account
list_of_containers              = ["*"]                         # Containers to access in storage account

# Helm chart version
helm_chart_version              = "2.0.7"                       # Helm chart version for e6data workspace

# Cost allocation tags
cost_tags = {
  App = "e6data"
}

# Default Node pool variables
default_node_pool_vm_size       = "Standard_B2s"
default_node_pool_node_count    = 1
default_node_pool_name          = "default"

# Karpenter Variables
karpenter_namespace             = "kube-system"                 # Namespace for Karpenter deployment
karpenter_service_account_name  = "karpenter"                   # Service account name for Karpenter
karpenter_release_version       = "0.5.0"                       # Karpenter release version
