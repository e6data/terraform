variable "subscription_id" {
  type        = string
  description = "The subscription ID of the Azure subscription in which the e6data resources will be deployed."
}

variable "workspace_name" {
  type        = string
  description = "Name of the e6data workspace to be created.."
}

variable "aks_cluster_name" {
  type        = string
  description = "The name of your Azure Kubernetes Service (AKS) cluster in which to deploy the e6data workspace."
}

variable "aks_resource_group_name" {
  type        = string
  description = "The name of the resource group where the AKS cluster is deployed."
}

variable "kubernetes_namespace" {
  type        = string
  description = "The namespace in the AKS cluster to deploy e6data workspace."
}

variable "data_resource_group_name" {
  type        = string
  description = "The name of the resource group containing data to be queried."
}

variable "data_storage_account_name" {
  type        = string
  description = "The name of the storage account containing data to be queried."
}

variable "admin_group_object_ids" {
  type        = list(string)
  description = "AAD groups to have admin access to the aks cluster"
}

variable "list_of_containers" {
  type        = list(string)
  description = "List of names of the containers inside the data storage account, that the 6data engine queries and require read access to."
  default     = ["*"]
}

variable "helm_chart_version" {
  type        = string
  description = "The version of the e6data helm chart to be deployed."
}

variable "kube_version" {
  type        = string
  description = "Version of Kubernetes used for the Agents"
}

variable "prefix" {
  type        = string
  description = "AZURE resource name prefix"
}

variable "region" {
  type        = string
  description = "AZURE region"
}

variable "cost_tags" {
  type        = map(string)
  description = "cost tags"
}

variable "vnet_name" {
  type        = string
  description = "Name of the vnet"
}

variable "private_cluster_enabled" {
  type        = bool
  description = "enable private cluster"
  default     = false
}

# Default Node pool Variables

variable "default_node_pool_name" {
  type        = string
  description = "The name of the default AKS node pool."
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "The size of the default AKS node pool vm."
}

variable "default_node_pool_node_count" {
  type        = string
  description = "The node pool count of default nodepool"
}

### Karpenter Variables
variable "karpenter_namespace" {
  description = "Namespace to deploy the Karpenter"
  type        = string
}

variable "karpenter_release_version" {
  description = "Version of the Karpenter cluster autoscaler Helm chart"
  type        = string
}

variable "karpenter_service_account_name" {
  description = "Service account name for the Karpenter"
  type        = string
}

variable "nodepool_instance_family" {
  type        = list(string)
  description = "Instance family for nodepool"
}

variable "nodepool_instance_arch" {
  type        = list(string)
  description = "Instance arch for nodepool"
}

variable "nodepool_cpu_limits" {
  type        = number
  description = "CPU limits for nodepool"
  default     = 100000
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  default     = ""
}

variable "key_vault_rg_name" {
  description = "Resource group in which the key vault is present"
  default     = "endpoint"
}

variable "nginx_ingress_controller_version" {
  description = "Helm chart version for the nginx ingress controller"
  type = string
}

variable "nginx_ingress_controller_namespace" {
  description = "Namespace to deploy the Karpenter"
  type        = string
}

variable "aks_subnet_cidr" {
  description = "aks subnet cidr"
  type = list(string)
}

variable "aci_subnet_cidr" {
  description = "aci subnet cidr"
  type = list(string)
}

variable "identity_pool_id" {
  type        = string
  description = "Identity pool ID from the e6data console."
}

variable "identity_id" {
  type        = string
  description = "Identity ID from the e6data console."
}
