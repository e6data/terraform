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

variable "default_node_pool_min_size" {
  type        = number
  description = "The minimum number of nodes in the default AKS node pool."
  default     = 1
}

variable "default_node_pool_max_size" {
  type        = number
  description = "The maximum number of nodes in the default AKS node pool."
}

## auto scaler profile
variable "scale_down_unneeded" {
  type        = string
  description = "How long a node should be unneeded before it is eligible for scale down."
}
variable "scale_down_delay_after_add" {
  type        = string
  description = "How long after the scale up of AKS nodes the scale down evaluation resumes."
}
variable "scale_down_unready" {
  type        = string
  description = "How long an unready node should be unneeded before it is eligible for scale down."
}
variable "scale_down_utilization_threshold" {
  type        = string
  description = "Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down."
}
