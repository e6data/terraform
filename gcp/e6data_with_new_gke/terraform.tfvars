# GCP Variables
gcp_region = "us-central1"
#The region in which the cluster master will be created, as well as the default node location. 

gcp_project_id = "gcp-project-id" # The ID of the GCP project


# e6data Workspace Variables
workspaces = [
  {
    name                                           = "workspace"
    namespace                                      = "namespace"
    spot_nodepool_instance_type                    = "c2d-highmem-32"
    ondemand_nodepool_instance_type                = "c2-standard-30"
    ondemand_highmem_nodepool_instance_type        = "c2d-highmem-32"
    max_instances_in_nodepool                      = 50
    serviceaccount_create                          = true
    serviceaccount_email                           = ""
    buckets                                        = ["*"]
    cost_labels                                    = {}
  }
]

helm_chart_version = "2.0.8" ### e6data workspace Helm chart version to be used.

# Network Variables
gke_subnet_ip_cidr_range = "10.100.0.0/18" # The subnet IP range for GKE
pod_ip_cidr_range        = "10.102.0.0/18" # The subnet IP range for pod IP addresses
service_ip_cidr_range    = "10.104.0.0/18" # The subnet IP range to use for service ClusterIPs

gke_e6data_master_ipv4_cidr_block = "10.103.4.0/28"
# The IP range in CIDR notation to use for the hosted master network
# This range will be used for assigning private IP addresses to the cluster master(s) and the ILB VIP
# This range must not overlap with any other ranges in use within the cluster's network, and it must be a /28 subnet

# Kubernetes Variables
gke_version           = "1.28"      # The version of GKE to use                
gke_encryption_state  = "ENCRYPTED" # The encryption state for GKE (It is recommended to use encryption)
gke_dns_cache_enabled = true        # The status of the NodeLocal DNSCache addon.

# GKE Cluster variables
cluster_name                   = "gkecluster"    # The name of the GKE cluster
kubernetes_cluster_zone        = ""              #If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master.
default_nodepool_instance_type = "e2-standard-2" # The default instance type for the node pool

gke_e6data_initial_node_count = 1  # The initial number of nodes in the GKE cluster
gke_e6data_max_pods_per_node  = 64 # The maximum number of pods per node in the GKE cluster

authorized_networks = {          #External networks that can access the Kubernetes cluster master through HTTPS.
  "44.194.151.209/32" : "e6data" #The default value is set to the CIDR of e6data(i.e.,44.194.151.209/32)
}

# Cost Labels
cost_labels = {} # Cost labels for tracking costs
# Note: The variable cost_labels only accepts lowercase letters ([a-z]), numeric characters ([0-9]), underscores (_) and dashes (-).

buckets = ["*"] ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.