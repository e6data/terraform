variable "aws_region" {
  type       = string
  description = "AWS region"
}

variable "cost_tags" {
  type = map(string)
  description = "cost tags"
}

variable "vpc_id" {
  type = string
  description = "vpc_id in whcih the eks cluster is present"
}

variable "subnet_ids" {
  type = list(string)
  description = "private subnets in which the eks is present"
}

variable "eks_cluster_name" {
  type = string
}

variable "port" {
  type = number
  default = 443
}

variable "eks_nic" {
  type = map(object({
    private_ips = list(string)
  }))
  description = "Map of EKS network interfaces with private IPs"
}