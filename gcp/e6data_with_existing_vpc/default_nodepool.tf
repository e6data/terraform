resource "google_container_node_pool" "default_gke_cluster_nodepool" {
  name_prefix       = "e6data-default"
  location          = var.gcp_region
  cluster           = module.gke_e6data.cluster_name
  node_count        = 2
  version           = var.gke_version
  max_pods_per_node = 64

  node_config {
    disk_size_gb = 30

    spot         = var.spot_enabled
    machine_type = var.default_nodepool_instance_type

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    labels = {
        "app" = "e6data"
        "e6data-workspace-name" = "default"
    }
  }

  autoscaling {
    total_min_node_count = 2
    total_max_node_count = 3
    location_policy = "ANY"
  }

  lifecycle {
    ignore_changes = [node_count, autoscaling, node_config[0].labels, version]
  }
}
