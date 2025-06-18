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

variable "name" {
  description = "Name of the VPC endpoint"
  type        = string
}