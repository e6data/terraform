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
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      self        = true
      cidr_blocks = []
    }
  ]
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
  default = [
    {
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
      self        = true
      cidr_blocks = []
      security_groups = []
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      self        = false
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      self        = true
      cidr_blocks = []
    }
  ]
}
