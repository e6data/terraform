variable "sec_grp_name" {
  type        = string
  description = "name of security group"
}

variable "vpc_id" {
  type        = string
  description = "The vpc ID"
}

variable "cidr_block" {
  type        = list(string)
  description = "CIDR block of VPC"
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    cidr_blocks = list(string)
  }))
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    cidr_blocks = list(string)
  }))
}
