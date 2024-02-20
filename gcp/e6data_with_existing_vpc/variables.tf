
variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID"
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

variable "cost_labels" {
  type = map(string)
  description = "cost labels"
}

########### NETWORK VARIABLES ###############
variable "vpc_name" {
  description = "vpc name to deploy resources"
  type        = string
}

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

variable "vpc_flow_logs_config" {
  type         = list(map(any))
  description  = "Subnet VPC Flow Logs configuration"
  default      = [
    {
      aggregation_interval            = "INTERVAL_1_MIN"          
      flow_sampling                   = 0.5                          
      metadata                        = "INCLUDE_ALL_METADATA"   
    }
  ]
}

variable "cloud_nat_ports_per_vm" {
  description = "The number of ports allocated per VM"
  type        = number
  default     = 0
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "The TCP transitory idle timeout in seconds"
  type        = number
  default     = 30
}

variable "cloud_nat_log_config" {
  description = "The configuration for the cloud NAT logs"
  type        = map
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
  type = list(string)
  default = [ "112892618221467749441" ]
}

variable "spot_enabled" {
  type        = bool
  description = "Enable spot instances in node pools"
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
}

// default nodepool variables
variable "default_nodepool_instance_type" {
  type        = string
  description = "the GKE instance type for default nodepool"
}
