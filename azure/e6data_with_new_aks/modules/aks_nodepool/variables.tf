variable "aks_cluster_name" {
  type = string
  description = "The name of the AKS cluster"
}

variable "nodepool_name" {
  type        = string
  description = "Name of the e6data workspace to be created.."
}

variable "enable_auto_scaling" {
  type        = string
  description = "enable auto scaling in the nodepool"
}

variable "vm_size" {
  type        = string
  description = "The VM size for the AKS node pool.(for example Standard_DS2_v2)"
}

variable "min_number_of_nodes" {
  type        = number
  description = "The minimum number of nodes in the AKS node pool."
  default     = 1
}

variable "max_number_of_nodes" {
  type        = number
  description = "The maximum number of nodes in the AKS node pool."
}

variable "zones" {
  type        = list(string)
  description = "Specifies a list of Availability Zones in which this Kubernetes Cluster Node Pool should be located"
  default     = ["1","2","3"]
}

variable "kube_version" {
  type        = string
  description = "Version of Kubernetes used for the Agents"
  default     = "1.26.6"
}

variable "priority" {
  type        = string
  description = "Regular/Spot"
  default     = "Spot"
}

variable "spot_max_price" {
  type        = number
  description = "maximum Spot price"
  default     = -1
}

variable "eviction_policy" {
  type        = string
  description = "Deallocate/Delete"
  default     = "Deallocate"
}

variable "vnet_subnet_id" {
  type        = string
  description = "subnet id for the aks nodepool"
}

variable "tags" {
  type = map(string)
  description = "cost tags"
}