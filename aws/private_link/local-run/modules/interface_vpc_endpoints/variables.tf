variable "vpc_id" {
  description = "VPC ID where the endpoint will be created"
  type        = string
}

variable "service_name" {
  description = "Service name for the VPC endpoint"
  type        = string
}

variable "vpc_endpoint_type" {
  description = "Type of the VPC endpoint (Interface or Gateway)"
  type        = string
  default     = "Interface"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the VPC endpoint"
  type        = list(string)
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  default     = []
}

variable "egress_rules" {
  description = "List of egress rules for the security group"
  default     = []
}

variable "name" {
  description = "Name of the VPC endpoint"
  type        = string
}

variable "workspace_name" {
  description = "Name of the VPC endpoint"
  type        = string
}