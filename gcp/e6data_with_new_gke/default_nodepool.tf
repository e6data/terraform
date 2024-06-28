resource "google_container_node_pool" "default_gke_cluster_nodepool" {
  name_prefix       = "e6data-default"
  location          = local.kubernetes_cluster_location
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
      "app"                   = "e6data"
      "e6data-workspace-name" = "default"
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [node_count, autoscaling, node_config[0].labels]
  }
}
