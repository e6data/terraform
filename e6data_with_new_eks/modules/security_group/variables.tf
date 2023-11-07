variable "sec_grp_name" {
  type        = string
  description = "name of security group"
}

variable "service_ports" {
  type        = list(string)
  description = "ports assigned for security group"
}

variable "vpc_id" {
  type        = string
  description = "The vpc ID"
}

variable "cidr_block" {
  type        = list(string)
  description = "CIDR block of VPC"
}