variable "location" {
  description = "The GCP region where resources will be created."
  type        = string
}

variable "total_max_node_count" {
  description = "The maximum number of nodes in the node pool."
  type        = number
}

variable "spot_enabled" {
  description = "Whether to use spot instances for the node pool."
  type        = bool
}

variable "machine_type" {
  description = "The machine type to use for the node pool."
  type        = string
}

variable "workspace_name" {
  description = "The name of the workspace."
  type        = string
}

variable "e6data_workspace_name" {
  description = "The E6DATA workspace name."
  type        = string
}

variable "gcp_region" {
  description = "The GCP region where resources will be created."
  type        = string
}

variable "workspace_write_role_name" {
  description = "The name of the workspace write role."
  type        = string
}

variable "workspace_read_role_name" {
  description = "The name of the workspace read role."
  type        = string
}

variable "buckets" {
  description = "List of GCP storage buckets."
  type        = list(string)
}

variable "gcp_project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "platform_sa_email" {
  description = "The email of the platform service account."
  type        = string
}

variable "cluster_viewer_role_name" {
  description = "The name of the cluster viewer role."
  type        = string
}

variable "workload_role_name" {
  description = "The name of the workload role."
  type        = string
}

variable "kubernetes_namespace" {
  description = "The Kubernetes namespace where resources will be created."
  type        = string
}

variable "target_pool_role_name" {
  description = "The name of the target pool role."
  type        = string
}

variable "helm_chart_version" {
  description = "The e6data workspace helm chart version."
  type        = string
}

variable "random_string" {
  type = string
}

variable "gke_cluster_id" {
  type = string
}

variable "control_plane_user" {
  description = "Control plane user to be added to e6data workspace"
  type        = list(string)
}

