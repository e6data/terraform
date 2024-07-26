# # Create GKE nodepool for workspace
resource "google_container_node_pool" "workspace" {
  name_prefix        = local.e6data_workspace_name
  cluster            = data.google_container_cluster.gke_cluster.id
  initial_node_count = 0
  autoscaling {
    total_min_node_count = 0
    total_max_node_count = var.max_instances_in_nodepool
    location_policy      = "ANY"
  }
  node_config {
    disk_size_gb = 100
    spot         = var.spot_enabled
    machine_type = var.nodepool_instance_type
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      e6data-workspace-name = var.workspace_name
      app                   = "e6data"
    }

    taint {
      key    = "e6data-workspace-name"
      value  = var.workspace_name
      effect = "NO_SCHEDULE"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# # Create GCS bucket for workspace
resource "google_storage_bucket" "workspace_bucket" {
  name     = "${local.e6data_workspace_name}-${random_string.random.result}"
  location = var.gcp_region
}