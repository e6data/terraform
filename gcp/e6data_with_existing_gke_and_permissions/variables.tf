variable "gcp_region" {
  description = "GCP region to run e6data workspace"
  type        = string
}

variable "gcp_project_id" {
  description = "GCP project ID to deploy e6data workspace"
  type        = string
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "kubernetes_cluster_zone" {
  description = "Kubernetes cluster zone (Only required for zonal clusters)"
  type        = string
}

variable "platform_sa_email" {
  description = "Platform service account email"
  type        = string
  default     = "e6-customer-prod-y0j6l@e6data-analytics.iam.gserviceaccount.com"
}

variable "helm_chart_version" {
  description = "Version of e6data workspace helm chart to deploy"
  type        = string
  default     = "1.0.1"
}

variable "control_plane_user" {
  description = "Control plane user to be added to e6data workspace"
  type        = list(string)
  default     = ["107317529457865758669"]
}

variable "buckets" {
  description = "List of bucket names to grant permissions to the e6data engine. Use ['*'] to grant permissions to all buckets."
  type        = list(string)
  default     = ["*"]
}

variable "cost_labels" {
  type        = map(string)
  description = "cost labels"
}

variable "workspace_sa_email" {
  type        = string
  description = "existing workspace sa email"
}

variable "workspace_bucket_write_role_ID" {
  type        = string
  description = "workspace write role name"
}

variable "workload_identity_role_ID" {
  type        = string
  description = "workload identity role name"
}


##new
variable "workspace_names" {
  type = list(object({
    name                    = string
    namespace               = string
    nodepool_instance_type  = string
    max_instances_in_nodepool = number
    spot_enabled            = bool
  }))
  default = [
    {
      name                    = "workspace1"
      namespace               = "namespace1"
      nodepool_instance_type  = "n1-standard-2"
      max_instances_in_nodepool = 50
      spot_enabled            = true
    },
    {
      name                    = "workspace2"
      namespace               = "namespace2"
      nodepool_instance_type  = "n1-standard-4"
      max_instances_in_nodepool = 50
      spot_enabled            = false
    }
  ]
}
