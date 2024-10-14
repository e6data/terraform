# General configuration
prefix                          = "e6"                             # Prefix for resources
region                          = "eastus"                          # Azure region
workspace_name                  = "workspace"                # Name of the e6data workspace to be created

# Details of existing resources
aks_resource_group_name         = "e6-rg"                         # Resource group to be use to deploy the AKS cluster in

# AKS cluster details
subscription_id                 = "12345678-1234-1234-1234-1234567890ab"  # Subscription ID of Azure subscription
aks_cluster_name                = "aks-cluster"                     # AKS cluster name
kube_version                    = "1.30"                            # Kubernetes version
kubernetes_namespace            = "e6data"                          # Namespace to deploy e6data workspace
admin_group_object_ids          = ["c436c2ee-18b7-4130-acc4-d7a01fe6ee7e"]  # A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster.

# Networking
cidr_block                      = ["10.220.0.0/16"]                 # CIDR block for the VNet

# Node pool configuration
nodepool_instance_family        = ["D", "E", "L"]                        # Instance families for node pools
nodepool_instance_arch          = ["arm64", "amd64"]                         # Instance architecture for node pools

# Data storage configuration
data_storage_account_name       = "datastorage"                   # Storage account name
data_resource_group_name        = "data-storage-rg"               # Resource group for storage account
list_of_containers              = ["*"]                           # Containers to access in storage account

# Helm chart version
helm_chart_version              = "2.0.12"                           # Helm chart version for e6data workspace

# Cost allocation tags
cost_tags = {                                                       # Tags used for cost allocation and management. Helps in tracking and optimizing resource costs.
  App = "e6data"
}

# Default Node pool variables
default_node_pool_vm_size       = "standard_d2_v5"                  # VM size for the default node pool
default_node_pool_node_count    = 3                                 # Number of nodes in the default node pool
default_node_pool_name          = "default"                         # Name of the default node pool

# Identity Pool Variables
identity_pool_id                = "identity-pool-12345"             # The identity pool ID available in the e6data console after clicking on the "Create Workspace" button and selecting AZURE
identity_id                     = "identity-67890"                  # The identity ID available in the e6data console, used for authentication and authorization in the workspace

# Karpenter Variables
karpenter_namespace             = "kube-system"                     # Namespace for Karpenter deployment
karpenter_service_account_name  = "karpenter"                       # Service account name for Karpenter
karpenter_release_version       = "0.5.4"                           # Karpenter release version

# Key Vault Configuration
key_vault_name                  = ""                                # Please provide the Key Vault name in which the certificate for the domain is present. If left blank, a new Key Vault will be created in the AKS resource group.
key_vault_rg_name               = ""                                # The resource group for the specified Key Vault. If left blank, it will default to the AKS resource group. For more info : https://docs.e6data.com/product-documentation/connectivity/endpoints

# Nginx Ingress Controller Configuration
nginx_ingress_controller_namespace = "kube-system"                 # Namespace where the Nginx Ingress Controller will be deployed
nginx_ingress_controller_version   = "4.7.1"                       # Version of the Nginx Ingress Controller to be installed
