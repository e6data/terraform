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

