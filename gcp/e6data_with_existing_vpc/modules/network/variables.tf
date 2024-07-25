variable "vpc_name" {
  description = "vpc name to deploy resources"
  type        = string
}

variable "workspace_name" {
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

variable "pod_ip_cidr_range" {
  description = "The CIDR block for the pods"
  type        = string
}

variable "service_ip_cidr_range" {
  description = "The CIDR block for the services"
  type        = string
}

variable "vpc_flow_logs_config" {
  type        = list(map(any))
  description = "Subnet VPC Flow Logs configuration"
  default     = []
}

variable "cloud_nat_ports_per_vm" {
  description = "The number of ports allocated per VM"
  type        = number
}

variable "cloud_nat_log_config" {
  description = "The configuration for the cloud NAT logs"
  type        = map(any)
}