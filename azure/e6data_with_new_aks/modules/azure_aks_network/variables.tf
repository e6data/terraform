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

variable "firewall_private_ip" {
  type        = string
  description = "Private IP address of the Azure Firewall in hub network"
}
