# General configuration
prefix         = "e6data"     # Prefix for resources
region         = "eastus"    # Azure region
workspace_name = "workspace" # Name of the e6data workspace to be created

# Details of existing resources
vnet_name               = "your-existing-vnet" # The name of the existing Virtual Network (VNet) where the resources will be deployed.
aks_resource_group_name = "your-resource-group"      # The resource group name that will contain the AKS cluster.

# AKS cluster details to be created
subscription_id        = "12345678-1234-1234-1234-1234567890ab"  # The Subscription ID of the Azure account where the resources will be created.
aks_cluster_name       = "aks-cluster"                           # The name of the AKS cluster to be created.
kube_version           = "1.30"                                  # The Kubernetes version to use for the AKS cluster.
kubernetes_namespace   = "e6data"                                # The namespace where the e6data workspace will be deployed within the AKS cluster.
admin_group_object_ids = ["abcdefgh-1234-5678-abcd-1234567890ab"] # A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster.

# Networking configuration
aks_subnet_cidr = ["10.220.131.0/24"] # The CIDR block for the subnet dedicated to the AKS cluster nodes.
aci_subnet_cidr = ["10.220.132.0/24"] # The CIDR block for the subnet reserved for Azure Container Instances (ACI), if integrated with the AKS cluster.

# Node pool configuration
nodepool_instance_family = ["D", "E", "L"]    # Instance families for node pools
nodepool_instance_arch   = ["arm64", "amd64"] # Instance architecture for node pools

# Data storage configuration
data_storage_account_name = "yourstorageaccount"     # Storage account name
data_resource_group_name  = "your-data-rg" # Resource group for storage account
list_of_containers        = ["*"]             # Containers to access in storage account

# Helm chart version
helm_chart_version = "2.1.12" # Helm chart version for e6data workspace

# Cost allocation tags
cost_tags = { # Tags used for cost allocation and management.
  App = "e6data"
}

# Default Node pool variables
default_node_pool_vm_size    = "standard_d2_v5" # VM size for the default node pool
default_node_pool_node_count = 3                # Number of nodes in the default node pool
default_node_pool_name       = "default"        # Name of the default node pool

# Identity Pool Variables
identity_pool_id = "your-identity-pool-id" # The identity pool ID available in the e6data console after clicking on the "Create Workspace"
identity_id      = "your-identity-id"      # The identity ID available in the e6data console, used for authentication and authorization in the workspace

# Karpenter Variables
karpenter_namespace            = "kube-system" # Namespace for Karpenter deployment
karpenter_service_account_name = "karpenter"   # Service account name for Karpenter
karpenter_release_version      = "1.4.0"       # Karpenter release version

debug_namespaces = ["kube-system"]

# Key Vault Configuration
key_vault_name    = "" # Please provide the Key Vault name in which the certificate for the domain is present. If left blank, a new Key Vault will be created in the AKS resource group.
key_vault_rg_name = "" # The resource group for the specified Key Vault. If left blank, it will default to the AKS resource group. For more info : https://docs.e6data.com/product-documentation/connectivity/endpoints

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
alb_subnet_cidr                      = ["10.220.133.0/24"]  # CIDR block for the ALB subnet (must provide at least 250 available IPs)

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

# Internal AGFC Configuration (optional)
agfc_internal_enabled             = false                 # Enable internal Azure Application Gateway for Containers
alb_internal_subnet_cidr          = []                    # CIDR block for internal ALB subnet (if enabled)
application_gateway_internal_name = "alb-agfc-internal"   # Name of the internal Application Gateway for Containers
