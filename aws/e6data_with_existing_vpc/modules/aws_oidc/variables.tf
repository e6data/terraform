variable "tls_url" {
  type        = string
  description = "tls url for oidc"
}

variable "policy_arn" {
  type        = set(string)
  description = "Managed or custom IAM policies to attach for role"
}

variable "eks_oidc_arn" {
  type        = string
  description = "arn of oidc for other service accounts to refer to"
}

variable "oidc_role_name" {
  type        = string
  description = "Name of OIDC role"
}

variable "kubernetes_namespace" {
  type        = string
  description = "namespace that service account belongs to"
}

variable "kubernetes_service_account_name" {
  type        = string
  description = "service account that OIDC role should be assigned to"
}