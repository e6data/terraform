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

variable "label_key" {
  type        = string
  default     = "app"
  description = "The label key to apply to Karpenter pods"
}

variable "label_value" {
  type        = string
  default     = "e6data"
  description = "The label value to apply to Karpenter pods"
}