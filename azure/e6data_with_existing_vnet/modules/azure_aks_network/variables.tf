variable "vnet_name" {
  type        = string
  description = "Name of the vnet"
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

variable "aks_subnet_cidr" {
  type        = list(string)
  description = "aks subnet cidr"
}

variable "aci_subnet_cidr" {
  type        = list(string)
  description = "aci subnet cidr"
}

variable "create_alb_subnet" {
  type        = bool
  description = "Create subnet for Application Gateway for Containers"
  default     = false
}

variable "alb_subnet_cidr" {
  type        = list(string)
  description = "ALB subnet CIDR (must provide at least 250 available IPs - /24 or larger)"
  default     = []
}

variable "create_alb_internal_subnet" {
  type        = bool
  description = "Create private subnet for internal Application Gateway for Containers"
  default     = false
}

variable "alb_internal_subnet_cidr" {
  type        = list(string)
  description = "Internal ALB subnet CIDR (must provide at least 250 available IPs - /24 or larger)"
  default     = []
}

