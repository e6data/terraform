workspace_name = "samplename"

gcp_project_id = "gcp-project-id"        ### The Google Cloud Platform (GCP) project ID to deploy the e6data workspace.
gcp_region = "us-central1"               ### The GCP region to deploy the e6data workspace.

cluster_name = "gke-cluster-name"
kubernetes_cluster_zone = ""
max_instances_in_nodepool = 60
nodepool_instance_type = "c2-standard-30"

kubernetes_namespace = "namespace1"

cost_labels = {}                            # Cost labels for tracking costs

buckets = ["*"]   ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.