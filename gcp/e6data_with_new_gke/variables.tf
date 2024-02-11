
variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "env" {
  type        = string
  description = "tag prefix to be added"
  default = "dev"
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace to deploy e6data workspaces"
  type = string
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type = string
}

variable "platform_sa_email" {
  description = "Platform service account email"
  type = string
  default = "e6-customer-dev-3s2et@e6data-analytics.iam.gserviceaccount.com"
}


########### NETWORK VARIABLES ###############
variable "workspace_name" {
  description = "value of the component name"
    type        = string
}

variable "gcp_region" {
  description = "The region to deploy to"
  type        = string
}

variable "gke_subnet_ip_cidr_range" {
  description = "The CIDR block for the GKE subnet"
  type        = string
}

variable "gke_cluster_secondary_range_name" {
  description = "The secondary range for the GKE cluster"
  type        = string
}

variable "gke_cluster_ipv4_cidr_block" {
  description = "The secondary range for the GKE cluster"
  type        = string
}

variable "gke_services_secondary_range_name" {
  description = "The secondary range for the GKE services"
  type        = string
}

variable "gke_services_ipv4_cidr_block" {
  description = "The secondary range for the GKE services"
  type        = string
}

variable "vpc_flow_logs_config" {
  type         = list(map(any))
  description  = "Subnet VPC Flow Logs configuration"
  default      = []
}

variable "cloud_nat_ports_per_vm" {
  description = "The number of ports allocated per VM"
  type        = number
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "The TCP transitory idle timeout in seconds"
  type        = number
}

variable "cloud_nat_log_config" {
  description = "The configuration for the cloud NAT logs"
  type        = map
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

variable "daily_maintenance_window_start" {
  type        = string
  description = "Daily maintenance window start time"
}

variable "gke_encryption_state" {
  type        = string
  description = "gke cluster encryption state"
}

variable "gke_encryption_key" {
  type        = string
  description = "gke cluster encryption key"
}

variable "gke_dns_cache_enabled" {
  type        = bool
  description = "Enable the Node DNS local caching"
}

variable "control_plane_user" {
  description = "Control plane user to be added to e6data workspace"
  type = list(string)
  default = [ "112892618221467749441" ]
}

variable "max_instances_in_nodegroup" {
  description = "Maximum number of instances in nodegroup"
  type = number
}


variable "gke_e6data_max_pods_per_node" {
  type        = string
  description = "Number of max pods per node"
}

variable "gke_e6data_instance_type" {
  type        = string
  description = "the GKE instance type"
}

variable "gke_e6data_initial_node_count" {
  type        = number
  description = "The initial node count for the default node pool"
}

variable "helm_chart_version" {
  description = "Version of e6data workspace helm chart to deploy"
  type = string
  default = "1.0.1"
}

# variable "oauth_scopes" {
#   description = "oauth scopes for gke cluster"
#   type        = list(string)
# }

// default nodepool variables
variable "default_nodepool_instance_type" {
  type        = string
  description = "the GKE instance type for default nodepool"
}
