variable "cidr_block" {
  type        = string
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
  default = "14.100.0.0/16"
}

variable "env" {
  type        = string
  description = "tag prefix to be added"
  default = "dev"
}

variable "excluded_az" {
  type        = list(string)
  description = "AZ where EKS doesnt have capacity"
  default = ["us-east-1e"]
}
