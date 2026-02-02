# General configuration
prefix                          = "e6data"                         # Prefix for resources
region                          = "eastus"                         # Azure region
workspace_name                  = "workspace"                      # Name of the e6data workspace to be created

# AKS cluster details
subscription_id                 = "12345678-1234-1234-1234-1234567890ab"  # Subscription ID of Azure subscription
aks_resource_group_name         = "your-resource-group"            # Resource group name for AKS cluster
aks_cluster_name                = "your-existing-aks-cluster"      # AKS cluster name
kubernetes_namespace            = "e6data"                         # Namespace to deploy e6data workspace

# Karpenter Node pool configuration
nodepool_instance_family        = ["D", "E", "L"]                  # Instance families for node pools
nodepool_instance_arch          = ["arm64", "amd64"]               # Instance architecture for node pools

# Identity Pool Variables
identity_pool_id                = "your-identity-pool-id"          # The identity pool ID available in the e6data console after clicking on the "Create Workspace" button and selecting AZURE
identity_id                     = "your-identity-id"               # The identity ID available in the e6data console, used for authentication and authorization in the workspace

# Data storage configuration
data_storage_account_name       = "yourstorageaccount"             # Storage account name
data_resource_group_name        = "your-data-rg"                   # Resource group for storage account
list_of_containers              = ["*"]                            # Containers to access in storage account

# e6data Helm chart version
helm_chart_version              = "2.1.12"                         # Helm chart version for e6data workspace

# Cost allocation tags
cost_tags = {                                                      # Tags used for cost allocation and management.
  App = "e6data"
}

# Key Vault Configuration
key_vault_name                  = ""                               # Please provide the Key Vault name in which the certificate for the domain is present. If left blank, a new Key Vault will be created in the AKS resource group.
key_vault_rg_name               = ""                               # The resource group for the specified Key Vault. If left blank, it will default to the AKS resource group. For more info : https://docs.e6data.com/product-documentation/connectivity/endpoints

debug_namespaces = ["kube-system"]

# Toggle to decide whether to deploy the akv2k8s Helm chart.
# Set to true to deploy, false to skip deployment.
deploy_akv2k8s = false

# Azure Application Gateway for Containers (AGFC) Configuration
agfc_enabled                         = true                 # Enable Azure Application Gateway for Containers deployment
alb_controller_enabled               = true                 # Enable ALB Controller deployment via Helm
alb_controller_namespace             = "kube-system"        # Kubernetes namespace where ALB Controller components will be deployed
alb_controller_helm_namespace        = "kube-system"        # Kubernetes namespace for Helm chart deployment
alb_controller_create_namespace      = false                # Create the ALB Controller namespace if it doesn't exist
alb_controller_helm_create_namespace = false                # Create the Helm deployment namespace if it doesn't exist
alb_controller_service_account_name  = "alb-controller-sa"  # Service account name for ALB Controller
alb_controller_version               = "1.7.12"             # Version of ALB Controller Helm chart
alb_controller_replica_count         = 2                    # Number of replicas for ALB Controller deployment
alb_controller_log_level             = "info"               # Log level for ALB Controller (debug, info, warn, error)
application_gateway_name             = "alb-agfc"           # Name of the Application Gateway for Containers resource

# ALB Subnet Configuration (required for AGFC)
# The subnet must be delegated to Microsoft.ServiceNetworking/trafficControllers
alb_subnet_id = ""  # Provide the ALB subnet ID from your existing VNet
vnet_id       = ""  # Provide the VNet ID where the AKS cluster is deployed

# ALB Controller resource limits and requests
alb_controller_resource_limits = {
  cpu    = "500m"
  memory = "512Mi"
}

alb_controller_resource_requests = {
  cpu    = "100m"
  memory = "128Mi"
}

# Additional tags for AGFC resources (optional)
agfc_tags = {}
