variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "eks_service_account_name" {
  type        = string
  description = "Kubernetes service account name"
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy the alb ingress controller"
}

variable "alb_ingress_controller_version" {
  type        = string
  description = "Version of the alb ingress controller"
  default     = "1.1.8"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "alb_controller_image_repository" {
  type = string
}

variable "alb_controller_image_tag" {
  type = string
}