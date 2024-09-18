variable "workspace_name" {
  description = "Name of e6data workspace to be created"
  type        = string
}

variable "eks_cluster_name" {
  description = "Name of e6data workspace to be created"
  type        = string
}

variable "aws_command_line_path" {
  description = "local aws installation bin path"
  type        = string
}

variable "cross_account_role_arn" {
  description = "Name of e6data workspace to be created"
  type        = string
}

variable "karpenter_node_role_arn" {
  description = "Name of e6data workspace to be created"
  type        = string
}