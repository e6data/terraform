variable "region" {
  type        = string
  description = "AZURE region"
}

variable "cluster_name" {
  type        = string
  description = "Name of AKS cluster"
}

variable "kube_version" {
  type        = string
  description = "The Kubernetes version in cluster"
}

variable "private_cluster_enabled" {
  type        = string
  description = "enable private cluster"
}

variable "resource_group_name" {
  type        = string
  description = "resource group name"
}

variable "admin_group_object_ids" {
  type        = list(string)
  description = "AAD groups to have admin access to the aks cluster"
  default     = ["c436c2ee-18b7-4130-acc4-d7a01fe6ee7e"]
}

variable "aci_subnet_name" {
  type        = string
  description = "name of the aci connector subnet"
}

variable "aks_subnet_id" {
  type        = string
  description = "subnet id of the aks cluster"
}

variable "tags" {
  type        = map(string)
  description = "cost tags"
}

##default nodepool vars
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

variable "public_ssh_key" {
  type        = string
  default     = ""
  description = "A custom ssh key to control access to the AKS cluster. Changing this forces a new resource to be created."
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "The username of the local administrator to be created on the Kubernetes cluster. Set this variable to `null` to turn off the cluster's `linux_profile`. Changing this forces a new resource to be created."
}