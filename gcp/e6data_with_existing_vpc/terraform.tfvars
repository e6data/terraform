# GCP Variables
gcp_region = "us-central1"
#The location (region or zone) in which the cluster master will be created, as well as the default node location.
#If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. 
#If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region, and with default node locations in those zones as well

gcp_project_id = "gcp-project-id" # The ID of the GCP project

# e6data Workspace Variables
workspace_name = "workspace" # The name of the e6data workspace
# Note: The variable workspace_name should meet the following criteria:
# a) Accepts only lowercase alphanumeric characters.
# b) Must have a minimum of 3 characters.

helm_chart_version = "2.0.7" ### e6data workspace Helm chart version to be used.

# Network Variables
vpc_name                 = "vpc"           # The name of the VPC
gke_subnet_ip_cidr_range = "10.100.0.0/18" # The subnet IP range for GKE

gke_e6data_master_ipv4_cidr_block = "10.103.4.0/28"
# The IP range in CIDR notation to use for the hosted master network
# This range will be used for assigning private IP addresses to the cluster master(s) and the ILB VIP
# This range must not overlap with any other ranges in use within the cluster's network, and it must be a /28 subnet

# Kubernetes Variables
gke_version           = "1.28.8"    # The version of GKE to use                
gke_encryption_state  = "DECRYPTED" # The encryption state for GKE (It is recommended to use encryption)
gke_dns_cache_enabled = true        # The status of the NodeLocal DNSCache addon.
spot_enabled          = false       # A boolean that represents whether the underlying node VMs are spot.

# GKE Cluster variables
cluster_name                   = "gkecluster" # The name of the GKE cluster
kubernetes_cluster_zone        = ""
default_nodepool_instance_type = "e2-standard-2" # The default instance type for the node pool

gke_e6data_initial_node_count = 1                # The initial number of nodes in the GKE cluster
gke_e6data_max_pods_per_node  = 64               # The maximum number of pods per node in the GKE cluster
gke_e6data_instance_type      = "c2-standard-30" # The instance type for the GKE nodes
max_instances_in_nodepool     = 50               # The maximum number of instances in a node group

authorized_networks = {          #External networks that can access the Kubernetes cluster master through HTTPS.
  "44.194.151.209/32" : "e6data" #The default value is set to the CIDR of e6data(i.e.,44.194.151.209/32)
}

# Kubernetes Namespace
kubernetes_namespace = "namespace" # The namespace to use for Kubernetes resources

# Cost Labels
cost_labels = {} # Cost labels for tracking costs
# Note: The variable cost_labels only accepts lowercase letters ([a-z]), numeric characters ([0-9]), underscores (_) and dashes (-).

buckets = ["*"] ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.