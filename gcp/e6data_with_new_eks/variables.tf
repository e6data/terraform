
variable "gcp_project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "docker_project_id" {
  type        = string
  description = "GCP Project ID of docker images"
}

variable "gcp_region" {
  type        = string
  description = "Region for creating the resource"
}

variable "component_name" {
    type        = string
    description = "Component name"
}

variable "google_service_apis" {
  type        = set(string)
  description = "Google service APIs to enable"
}

########### NETWORK VARIABLES ###############
variable "gke_subnet_ip_cidr_range" {
  type        = string
  description = "Subnet CIDR block"
}

variable "gke_cluster_secondary_range_name" {
  type        = string
  description = "Cluster IP range name for GKE apps cluster"
}

variable "gke_cluster_ipv4_cidr_block" {
  type        = string
  description = "Cluster IP ranges for GKE apps cluster"
}

variable "gke_services_secondary_range_name" {
  type        = string
  description = "Services IP range name for GKE apps cluster"
}

variable "gke_services_ipv4_cidr_block" {
  type        = string
  description = "Services IP ranges for GKE apps cluster"
}

######### NAT CONFIGURATION ###################
variable "cloud_nat_ports_per_vm" {
  description = "The minimum number of ports per VM for cloud nat"
  type        = string
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "The value for tcp transitory idle timeout in sec"
  type        = string
}

variable "cloud_nat_log_config" {
  description = "The minimum number of ports per VM for cloud nat"
  type = object({
    enable = bool
    filter = string
  })
}

variable "vpc_flow_logs_config" {
  type         = list(map(any))
  description  = "Subnet VPC Flow Logs configuration"
  default      = []
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


########### GKE-APPS VARIABLES ##############
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

variable "gke_e6data_auto_min_count" {
  type        = number
  description = "The minimum number of VMs in the pool"
}

variable "gke_e6data_auto_max_count" {
  type        = number
  description = "The maximum number of VMs in the pool"
}

variable "gke_e6data_namespaces" {
  type        = set(string)
  description = "Namespaces to be created after cluster creation"
}

variable "gke_e6data_master_ipv4_cidr_block" {
  type        = string
  description = "IPv4 CIDR Block for platform Master Nodes"
}



////////existing
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

variable "max_instances_in_nodegroup" {
  description = "Maximum number of instances in nodegroup"
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
  default = "e6-customer-prod-xpopt@e6data-analytics.iam.gserviceaccount.com"
}

variable "nodegroup_instance_type" {
  description = "Instance type for nodegroup"
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
  default = [ "106303122587621488869" ]
}