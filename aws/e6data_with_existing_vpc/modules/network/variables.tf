variable "vpc_id" {
  type        = string
  description = "VPC ID to create e6data resources"
}

variable "env" {
  type        = string
  description = "tag prefix to be added"
  default     = "dev"
}

variable "excluded_az" {
  type        = list(string)
  description = "AZ where EKS doesnt have capacity"
  default     = ["us-east-1e"]
}

variable "workspace_name" {
  type        = string
  description = "Name of the e6data workspace to be created."
  default     = "dummy"
}

variable "region" {
  type        = string
  description = "AWS region of the EKS cluster."
  default     = "us-east-1"
}
variable "private_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}