variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "interruption_queue_name" {
  type        = string
  description = "EKS cluster name"
}

variable "eks_endpoint" {
  type        = string
  description = "EKS cluster name"
}

variable "service_account_name" {
  type        = string
  description = "service_account_name for the karpenter"
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy the karpenter helm release"
}

variable "karpenter_release_version" {
  type        = string
  description = "Version of the karpenter helm release"
}

variable "controller_role_arn" {
  description = "ARN of the IAM role associated with the Karpenter controller"
  type        = string
}