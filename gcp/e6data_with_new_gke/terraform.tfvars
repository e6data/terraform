env = "dev"
workspace_name="harshith"
gcp_region = "us-central1"
cluster_name="harshith"
gcp_project_id="numeric-datum-351807"
kubernetes_namespace="harshith"

######## GCP NETWORK VARIABLES ############
gke_subnet_ip_cidr_range           = "10.100.0.0/18"  # Subnet IP Range

gke_services_secondary_range_name      = "perf-ci-gke-cluster-service-ip-range"
gke_services_ipv4_cidr_block           = "10.101.64.0/20"  # IP address range of the services IPs in this cluster

gke_cluster_secondary_range_name       = "perf-ci-gke-cluster-pod-ip-range"
gke_cluster_ipv4_cidr_block            = "10.112.0.0/15"  # IP address range for the cluster pod IPs

vpc_flow_logs_config = [
  {
    aggregation_interval = "INTERVAL_1_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
]
######### NAT CONFIGURATION ###################
cloud_nat_ports_per_vm = "0"
tcp_transitory_idle_timeout_sec  = "30"
cloud_nat_log_config             = null

########## GKE VARIABLES ###########
gke_version                     = "1.26"
gke_e6data_master_ipv4_cidr_block     = "10.103.4.0/28"  # IP range to use for the hosted management master network

daily_maintenance_window_start  = "03:00"

gke_encryption_state            = "ENCRYPTED"
gke_encryption_key              = ""
gke_dns_cache_enabled           = true

######## GKE-APPS VARIABLES ########
gke_e6data_initial_node_count     = 1
gke_e6data_max_pods_per_node      = 64
gke_e6data_instance_type          = "e2-medium"
max_instances_in_nodegroup        = 50