# e6data Workspace Variables
workspace_name = "workspace" # The name of the e6data workspace
# Note: The variable workspace_name should meet the following criteria:
# a) Accepts only lowercase alphanumeric characters.
# b) Must have a minimum of 3 characters.

gcp_project_id = "gcp-project-id" ### The Google Cloud Platform (GCP) project ID to deploy the e6data workspace.
gcp_region     = "us-central1"    ### The GCP region to deploy the e6data workspace.

helm_chart_version = "2.1.4" ### e6data workspace Helm chart version to be used.

cluster_name              = "gke-cluster-name" # The name of the GKE cluster
kubernetes_cluster_zone   = ""
max_instances_in_nodepool = 60
nodepool_instance_type    = "c2-standard-30"
spot_enabled              = true # A boolean that represents whether the underlying node VMs are spot.

kubernetes_namespace = "namespace1"

cost_labels = {} # Cost labels for tracking costs
# Note: The variable cost_labels only accepts lowercase letters ([a-z]), numeric characters ([0-9]), underscores (_) and dashes (-).

buckets = ["*"] ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.