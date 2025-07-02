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

variable "subnet_tag_key" {
  type        = string
  description = "Tag key for identifying private subnets."
}

variable "subnet_tag_value" {
  type        = string
  description = "Tag value for identifying private subnets."
}