variable "cluster_name" {
  type        = string
  description = "The GKE cluster name"
}

variable "region" {
  type = string
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "IPv4 CIDR Block for Master Nodes"
}

variable "cluster_secondary_range_name" {
  type        = string
  description = "The secondary range to be used as for the cluster CIDR block"
}

variable "services_secondary_range_name" {
  type        = string
  description = "The secondary range to be used as for the services CIDR block"
}

variable "initial_node_count" {
  description = "The initial node count for the default node pool"
}

variable "daily_maintenance_window_start" {
  type        = string
  description = "Daily maintenance window start time"
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

variable "gke_encryption_key" {
  type        = string
  description = "gke cluster encryption key"
}

variable "dns_cache_enabled" {
  type        = bool
  description = "Enable the Node DNS local caching"
  default     = false
}

variable "oauth_scopes" {
  description = "oauth scopes for gke cluster"
  type        = list(string)
}

