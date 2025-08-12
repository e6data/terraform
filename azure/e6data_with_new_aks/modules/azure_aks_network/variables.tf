variable "cidr_block" {
  type        = list(string)
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
  default     = []
}

variable "existing_vnet_name" {
  type        = string
  description = "Name of the existing VNet to use"
}

variable "existing_vnet_resource_group_name" {
  type        = string
  description = "Resource group name of the existing VNet"
}

variable "aks_subnet_name" {
  type        = string
  description = "Name for the AKS subnet to be created"
  default     = "subnet-01"
}

variable "aks_subnet_address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the AKS subnet to be created"
}

variable "aci_subnet_name" {
  type        = string
  description = "Name for the ACI subnet to be created"
  default     = "e6-subnet-aci"
}

variable "aci_subnet_address_prefixes" {
  type        = list(string)
  description = "Address prefixes for the ACI subnet to be created"
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

variable "firewall_private_ip" {
  type        = string
  description = "Private IP address of the Azure Firewall in hub network"
}
