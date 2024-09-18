variable "workspace_name" {
  description = "The name of the workspace."
  type        = string
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "karpenter_node_role_arn" {
  description = "ARN of the Karpenter node role."
  type        = string
}

variable "cross_account_role_arn" {
  description = "ARN of the cross-account role."
  type        = string
}

variable "aws_command_line_path" {
  description = "Path to AWS command line executable."
  type        = string
}

variable "authentication_mode" {
  description = "The authentication mode to use."
  type        = string
}