variable "karpenter_version" {
  description = "Version of Karpenter"
  type        = string
  default     = "kube-system"
}

variable "karpenter_namespace" {
  description = "Namespace for Karpenter"
  type        = string
  default     = "kube-system"
}


variable "provider" {
  description = "provider for Karpenter"
  type        = string
  default     = "e6data"
}

