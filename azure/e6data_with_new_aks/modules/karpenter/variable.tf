variable "karpenter_version" {
  description = "Version of Karpenter"
  type        = string
}

variable "karpenter_namespace" {
  description = "Namespace for Karpenter"
  type        = string
  default     = "kube-system"
}

variable "aks_cluster_name" {
  type        = string
  description = "The name of your Azure Kubernetes Service (AKS) cluster in which to deploy the e6data workspace."
}

variable "aks_cluster_endpoint" {
  type        = string
  description = "The endpoint of the aks cluster in which to deploy the e6data workspace."
}

# variable "bootstrap_token" {
#   type        = string
#   description = "The bootstrap_token of the aks cluster in which to deploy the e6data workspace."
# }

variable "subscription_id" {
  type        = string
  description = "The Azure subscription_id."
}

variable "location" {
  type        = string
  description = "AZURE location"
}

variable "aks_subnet_id" {
  type        = string
  description = "AKS subnet ID"
}

variable "node_resource_group" {
  type        = string
  description = "AKS subnet ID"
}

variable "karpenter_service_account_name" {
  description = "Service account name for the Karpenter cluster autoscaler"
  type        = string
}

variable "karpenter_managed_identity_client_id" {
  description = "managed identity name for the Karpenter cluster autoscaler"
  type        = string
}

variable "node_identities" {
  description = "node identities"
  type        = string
}

variable "public_ssh_key" {
  description = "public ssh key"
  type        = string
}

variable "bootstrap_token" {
  description = "bootstrap token"
  type        = string
}