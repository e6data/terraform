variable "env" {
    description = "The environment name"
    type        = string
}

variable "component_name" {
  description = "value of the component name"
    type        = string
}

variable "gcp_region" {
  description = "The region to deploy to"
  type        = string
}

variable "gke_subnet_ip_cidr_range" {
  description = "The CIDR block for the GKE subnet"
  type        = string
}

variable "gke_cluster_secondary_range_name" {
  description = "The secondary range for the GKE cluster"
  type        = string
}

variable "gke_cluster_ipv4_cidr_block" {
  description = "The secondary range for the GKE cluster"
  type        = string
}

variable "gke_services_secondary_range_name" {
  description = "The secondary range for the GKE services"
  type        = string
}

variable "gke_services_ipv4_cidr_block" {
  description = "The secondary range for the GKE services"
  type        = string
}

variable "vpc_flow_logs_config" {
  type         = list(map(any))
  description  = "Subnet VPC Flow Logs configuration"
  default      = []
}

variable "cloud_nat_ports_per_vm" {
  description = "The number of ports allocated per VM"
  type        = number
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "The TCP transitory idle timeout in seconds"
  type        = number
}

variable "cloud_nat_log_config" {
  description = "The configuration for the cloud NAT logs"
  type        = map
}