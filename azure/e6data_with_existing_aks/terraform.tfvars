# General configuration
prefix                          = "e6"                             # Prefix for resources
region                          = "eastus"                          # Azure region
workspace_name                  = "workspace"                # Name of the e6data workspace to be created

# AKS cluster details
subscription_id                 = "12345678-1234-1234-1234-1234567890ab"  # Subscription ID of Azure subscription
aks_resource_group_name         = "e6-rg"                   # Resource group name for AKS cluster
aks_cluster_name                = "aks-cluster"              # AKS cluster name
kubernetes_namespace            = "e6data"                          # Namespace to deploy e6data workspace

# Karpenter Node pool configuration
nodepool_instance_family        = ["D", "E", "L"]                        # Instance families for node pools
nodepool_instance_arch          = ["arm64", "amd64"]                     # Instance architecture for node pools

# Identity Pool Variables
identity_pool_id                = "identity-pool-12345"             # The identity pool ID available in the e6data console after clicking on the "Create Workspace" button and selecting AZURE
identity_id                     = "identity-67890"                  # The identity ID available in the e6data console, used for authentication and authorization in the workspace

# Data storage configuration
data_storage_account_name       = "datastorage"                   # Storage account name
data_resource_group_name        = "data-storage-rg"               # Resource group for storage account
list_of_containers              = ["*"]                           # Containers to access in storage account

# e6data Helm chart version
helm_chart_version              = "2.1.7"                           # Helm chart version for e6data workspace

# Cost allocation tags
cost_tags = {                                                       # Tags used for cost allocation and management.
  App = "e6data"
}

# Key Vault Configuration
key_vault_name                  = ""                               # Please provide the Key Vault name in which the certificate for the domain is present. If left blank, a new Key Vault will be created in the AKS resource group.
key_vault_rg_name               = ""                               # The resource group for the specified Key Vault. If left blank, it will default to the AKS resource group. For more info : https://docs.e6data.com/product-

# Nginx Ingress Controller Configuration
nginx_ingress_controller_namespace = "kube-system"                 # Namespace where the Nginx Ingress Controller will be deployed
nginx_ingress_controller_version   = "4.7.1"                       # Version of the Nginx Ingress Controller to be installed

# Toggle to decide whether to deploy the akv2k8s Helm chart.
# Set to true to deploy, false to skip deployment.
deploy_akv2k8s = false

# Toggle to decide whether to deploy the NGINX Ingress Controller.
# Set to true to deploy, false to skip deployment.
deploy_nginx_ingress = false