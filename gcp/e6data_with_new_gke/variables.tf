
variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "kubernetes_cluster_zone" {
  description = "Kubernetes cluster zone (Only required for zonal clusters)"
  type        = string
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "platform_sa_email" {
  description = "Platform service account email"
  type        = string
  default     = "e6-customer-prod-y0j6l@e6data-analytics.iam.gserviceaccount.com"
}

variable "cost_labels" {
  type        = map(string)
  description = "cost labels"
}

########### NETWORK VARIABLES ###############
variable "workspaces" {
  type = list(object({
    name                    = string
    namespace               = string
    spot_nodepool_instance_type  = string
    ondemand_nodepool_instance_type  = string
    max_instances_in_nodepool = number
    cost_labels             = map(string)
    serviceaccount_create   = bool
    serviceaccount_email    = string
    buckets                 = list(string)
  }))

  default = [
    {
      name                    = "workspace1"
      namespace               = "namespace1"
      spot_nodepool_instance_type      = "c2-standard-30"
      ondemand_nodepool_instance_type  = "c2-standard-30"
      max_instances_in_nodepool = 50
      cost_labels             = {}
      serviceaccount_create   = true
      serviceaccount_email    = ""
      buckets                 = ["*"]
    }
  ]
}

variable "gcp_region" {
  description = "The region to deploy to"
  type        = string
}

variable "gke_subnet_ip_cidr_range" {
  description = "The CIDR block for the GKE subnet"
  type        = string
}

variable "pod_ip_cidr_range" {
  description = "The CIDR block for the pods"
  type        = string
}

variable "service_ip_cidr_range" {
  description = "The CIDR block for the services"
  type        = string
}

variable "vpc_flow_logs_config" {
  type        = list(map(any))
  description = "Subnet VPC Flow Logs configuration"
  default = [
    {
      aggregation_interval = "INTERVAL_1_MIN"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  ]
}

variable "cloud_nat_ports_per_vm" {
  description = "The number of ports allocated per VM"
  type        = number
  default     = 0
}

variable "cloud_nat_log_config" {
  description = "The configuration for the cloud NAT logs"
  type        = map(any)
  default     = null
}

variable "gke_e6data_master_ipv4_cidr_block" {
  type        = string
  description = "IPv4 CIDR Block for platform Master Nodes"
}

######### GKE VARIABLES ###################
variable "gke_version" {
  type        = string
  description = "The kubernetes version to use"
}

variable "gke_encryption_state" {
  type        = string
  description = "gke cluster encryption state"
}

variable "gke_dns_cache_enabled" {
  type        = bool
  description = "Enable the Node DNS local caching"
}

variable "control_plane_user" {
  description = "Control plane user to be added to e6data workspace"
  type        = list(string)
  default     = ["107317529457865758669"]
}

variable "gke_e6data_max_pods_per_node" {
  type        = string
  description = "Number of max pods per node"
}

variable "gke_e6data_initial_node_count" {
  type        = number
  description = "The initial node count for the default node pool"
}

variable "helm_chart_version" {
  description = "Version of e6data workspace helm chart to deploy"
  type        = string
}

// default nodepool variables
variable "default_nodepool_instance_type" {
  type        = string
  description = "the GKE instance type for default nodepool"
}

variable "buckets" {
  description = "List of bucket names to grant permissions to the e6data engine. Use ['*'] to grant permissions to all buckets."
  type        = list(string)
  default     = ["*"]
}

variable "deletion_protection" {
  type        = bool
  description = "Whether or not to allow Terraform to destroy the cluster. Unless this field is set to false in Terraform state, a terraform destroy or terraform apply that would delete the cluster will fail."
  default     = false
}


variable "authorized_networks" {
  type        = map(string)
  description = "authorized_networks"
}