variable "region" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "hub_cidr_block" {
  description = "CIDR block for hub VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}