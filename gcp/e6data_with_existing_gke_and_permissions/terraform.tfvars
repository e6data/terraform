# e6data Workspace Variables
workspace_names = [
    {
      name                    = "workspace1"
      namespace               = "namespace1"
      nodepool_instance_type  = "c2d-highmem-32"
      max_instances_in_nodepool = 50
      spot_enabled            = true
    },
    {
      name                    = "workspace2"
      namespace               = "namespace2"
      nodepool_instance_type  = "c2d-highmem-32"
      max_instances_in_nodepool = 50
      spot_enabled            = true
    }
  ]
# The name of the e6data workspace
# Note: The variable workspace_name should meet the following criteria:
# a) Accepts only lowercase alphanumeric characters.
# b) Must have a minimum of 3 characters.

gcp_project_id = "gcp-project-id" ### The Google Cloud Platform (GCP) project ID to deploy the e6data workspace.
gcp_region     = "us-central1"    ### The GCP region to deploy the e6data workspace.

helm_chart_version = "2.0.9" ### e6data workspace Helm chart version to be used.

cluster_name              = "cluster-1" # The name of the GKE cluster
kubernetes_cluster_zone   = ""

cost_labels = {} # Cost labels for tracking costs
# Note: The variable cost_labels only accepts lowercase letters ([a-z]), numeric characters ([0-9]), underscores (_) and dashes (-).

buckets = ["*"] ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.

workspace_sa_email = "test-1@gcp-project-id.iam.gserviceaccount.com" ###Existing service account that has access to the data buckets
workspace_bucket_write_role_ID = "projects/gcp-project-id/roles/CustomRole958"
workload_identity_role_ID = "projects/gcp-project-id/roles/CustomRole270"
