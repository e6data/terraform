variable "subscription_id" {
  type        = string
  description = "The subscription ID of the Azure subscription in which the e6data resources will be deployed."
}

variable "workspace_name" {
  type        = string
  description = "Name of the e6data workspace to be created."
}

variable "e6data_app_secret_expiration_time" {
  type        = string
  description = "A relative duration for which the password is valid until, for example 240h (10 days) or 2400h30m."
  default     = "3600h"
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

variable "list_of_containers" {
  type        = list(string)
  description = "List of names of the containers inside the data storage account that the e6data engine queries and requires read access to."
  default     = ["*"]
}

variable "helm_chart_version" {
  type        = string
  description = "The version of the e6data helm chart to be deployed."
}

variable "kube_version" {
  type        = string
  description = "Version of Kubernetes used for the Agents."
}

variable "priority" {
  type        = list(string)
  description = "Regular/Spot"
  default     = ["spot"]
}

variable "prefix" {
  type        = string
  description = "AZURE resource name prefix."
}

variable "region" {
  type        = string
  description = "AZURE region."
}

variable "cost_tags" {
  type        = map(string)
  description = "Cost tags."
}

variable "cidr_block" {
  type        = list(string)
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)."
}

variable "private_cluster_enabled" {
  type        = string
  description = "Enable private cluster."
}

# Default Node pool Variables

variable "default_node_pool_name" {
  type        = string
  description = "The name of the default AKS node pool."
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "The size of the default AKS node pool VM."
}

variable "default_node_pool_node_count" {
  type        = string
  description = "The node pool count of the default node pool."
}

### Karpenter Variables

variable "karpenter_namespace" {
  type        = string
  description = "Namespace to deploy the Karpenter."
}

variable "karpenter_release_version" {
  type        = string
  description = "Version of the Karpenter cluster autoscaler Helm chart."
}

variable "karpenter_service_account_name" {
  type        = string
  description = "Service account name for the Karpenter."
}

variable "nodepool_instance_family" {
  type        = list(string)
  description = "Instance family for node pool."
}

variable "nodepool_cpu_limits" {
  type        = number
  description = "CPU limits for node pool."
  default     = 100000
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault."
  default     = ""
}

variable "key_vault_rg_name" {
  type        = string
  description = "Resource group in which the key vault is present."
  default     = "endpoint"
}

variable "nginx_ingress_controller_namespace" {
  type        = string
  description = "NGINX ingress controller namespace."
  default     = "kube-system"
}

variable "nginx_ingress_controller_version" {
  type        = string
  description = "Version of the NGINX Ingress Controller."
  default     = "4.7.1"
}