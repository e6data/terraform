variable "cidr_block" {
  type        = list(string)
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "prefix" {
  type        = string
  description = "tag prefix to be added"
  default     = "e6data"
}


variable "resource_group_name" {
  type        = string
  description = "resource group name"
}

variable "region" {
  type        = string
  description = "AZURE region"
}

variable "create_alb_subnet" {
  type        = bool
  description = "Create subnet for Application Gateway for Containers"
  default     = false
}

variable "alb_subnet_prefix_length" {
  type        = number
  description = "Prefix length for ALB subnet (must provide at least 250 available IPs - /24 or larger)"
  default     = 8  # This will create a /24 subnet when VNet is /16
}

variable "alb_subnet_cidr_offset" {
  type        = number
  description = "CIDR offset for ALB subnet within the VNet"
  default     = 2  # Use third subnet block (after AKS and ACI)
}

variable "create_alb_internal_subnet" {
  type        = bool
  description = "Create private subnet for internal Application Gateway for Containers"
  default     = false
}

variable "alb_internal_subnet_prefix_length" {
  type        = number
  description = "Prefix length for internal ALB subnet (must provide at least 250 available IPs - /24 or larger)"
  default     = 8  # This will create a /24 subnet when VNet is /16
}

variable "alb_internal_subnet_cidr_offset" {
  type        = number
  description = "CIDR offset for internal ALB subnet within the VNet"
  default     = 3  # Use fourth subnet block (after AKS, ACI, and ALB)
}
