workspace_name = "govinda"

gcp_project_id = "<GCP_PROJECT_ID>"        ### The Google Cloud Platform (GCP) project ID to deploy the e6data workspace.
gcp_region = "us-central1"      ### The GCP region to deploy the e6data workspace.

cluster_name = "govinda"
kubernetes_cluster_zone = ""
max_instances_in_nodepool = 60
nodepool_instance_type = "c2-standard-30"

kubernetes_namespace = "govinda"

buckets = ["*"]   ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.