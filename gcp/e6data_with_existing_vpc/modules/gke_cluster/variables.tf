variable "cluster_name" {
  type        = string
  description = "The GKE cluster name"
}

variable "workspace_name" {
  description = "value of the component name"
  type        = string
}

variable "region" {
  type = string
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "IPv4 CIDR Block for Master Nodes"
}

variable "initial_node_count" {
  description = "The initial node count for the default node pool"
}

variable "gke_version" {
  type        = string
  description = "The kubernetes version to use"
}

variable "subnetwork" {
  description = "Subnetwork"
}

variable "network" {
  description = "Network"
}

variable "gke_encryption_state" {
  type        = string
  description = "gke cluster encryption state"
}

variable "dns_cache_enabled" {
  type        = bool
  description = "Enable the Node DNS local caching"
  default     = false
}

variable "cost_labels" {
  type        = map(string)
  description = "cost labels"
}

variable "deletion_protection" {
  type        = bool
  description = "Whether or not to allow Terraform to destroy the cluster. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the cluster will fail."
}

variable "authorized_networks" {
  type        = map(string)
  description = "authorized_networks"
}

variable "gke_encryption_key" {
  type        = string
  description = "gke cluster encryption key"
}