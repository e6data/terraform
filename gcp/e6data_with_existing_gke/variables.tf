variable "gcp_region" {
  description = "GCP region to run e6data workspace"
  type = string
}

variable "gcp_project_id" {
  description = "GCP project ID to deploy e6data workspace"
  type = string
}

variable "workspace_name" {
  description = "Name of e6data workspace to be created"
  type = string
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type = string
}

variable "max_instances_in_nodepool" {
  description = "Maximum number of instances in nodepool"
  type = number
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace to deploy e6data workspaces"
  type = string
}

variable "kubernetes_cluster_zone" {
  description = "Kubernetes cluster zone (Only required for zonal clusters)"
  type = string
}

variable "platform_sa_email" {
  description = "Platform service account email"
  type = string
  default = "e6-customer-dev-3s2et@e6data-analytics.iam.gserviceaccount.com"
}

variable "nodepool_instance_type" {
  description = "Instance type for nodepool"
  type = string
}

variable "helm_chart_version" {
  description = "Version of e6data workspace helm chart to deploy"
  type = string
  default = "1.0.1"
}

variable "control_plane_user" {
  description = "Control plane user to be added to e6data workspace"
  type = list(string)
  default = [ "112892618221467749441" ]
}

variable "buckets" {
  description = "List of bucket names to grant permissions to the e6data engine. Use ['*'] to grant permissions to all buckets."
  type        = list(string)
  default     = ["*"]
}

variable "cost_labels" {
  type = map(string)
  description = "cost labels"
}
