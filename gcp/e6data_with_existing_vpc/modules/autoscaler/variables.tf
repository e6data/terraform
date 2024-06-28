variable "cluster_name" {
  type        = string
  description = "Name of kubernetes cluster"
}

variable "helm_chart_version" {
  type        = string
  description = "Helm chart version to be used"
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy in helm chart"
}

variable "helm_chart_name" {
  type = string
  description = "Name of helm chart"
}

variable "service_account_name" {
  type = string
  description = "Kubernetes Service Account Name for RBAC"
}

variable "tolerations_key" {
  type        = string
  description = "tolerations key"
}

variable "tolerations_value" {
  type        = string
  description = "tolerations value"
}
variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "nodepool_name" {
  type        = string
  description = "e6data nodepool name"
}