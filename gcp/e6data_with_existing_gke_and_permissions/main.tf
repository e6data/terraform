# # Create GKE nodepool for workspace
resource "google_container_node_pool" "workspace" {
  count = length(var.workspace_names)

  name_prefix        = var.workspace_names[count.index].name
  cluster            = data.google_container_cluster.gke_cluster.id
  initial_node_count = 0

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = var.workspace_names[count.index].max_instances_in_nodepool
    location_policy      = "ANY"
  }

  node_config {
    disk_size_gb = 100
    spot         = var.workspace_names[count.index].spot_enabled
    machine_type = var.workspace_names[count.index].nodepool_instance_type
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      e6data-workspace-name = var.workspace_names[count.index].name
      app                   = "e6data"
    }

    taint {
      key    = "e6data-workspace-name"
      value  = var.workspace_names[count.index].name
      effect = "NO_SCHEDULE"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# # Create GCS bucket for workspace
resource "google_storage_bucket" "workspace_bucket" {
  count    = length(var.workspace_names)
  name     = "${var.workspace_names[count.index].name}-${random_string.random[count.index].result}"
  location = var.gcp_region
}

## IAM binding to the customer serviceaaccount to access workspace gcs bucket
resource "google_storage_bucket_iam_binding" "workspace_write_binding" {
  count  = length(var.workspace_names)
  bucket = google_storage_bucket.workspace_bucket[count.index].name
  role   = var.workspace_bucket_write_role_ID
  members = [
    "serviceAccount:${var.workspace_sa_email}",
    "serviceAccount:${var.platform_sa_email}"
  ]

  depends_on = [ google_storage_bucket.workspace_bucket ]
}

# Create IAM policy binding for workspace service account and Kubernetes cluster
resource "google_project_iam_member" "workspace_ksa_mapping" {
  count   = length(var.workspace_names)
  project = var.gcp_project_id
  role    = var.workload_identity_role_ID
  member =  "serviceAccount:${var.gcp_project_id}.svc.id.goog[${var.workspace_names[count.index].namespace}/${var.workspace_names[count.index].name}]"
}