## Private & Regional Cluster
resource "google_container_cluster" "gke_cluster" {

  name               = var.cluster_name
  location           = var.region
  min_master_version = var.gke_version
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  logging_service    = "logging.googleapis.com/kubernetes"
  network            = var.network
  subnetwork         = var.subnetwork
  initial_node_count = var.initial_node_count

  workload_identity_config {
  workload_pool = "${data.google_client_config.default.project}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
    enable_private_endpoint = false
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    dns_cache_config {
      enabled = var.dns_cache_enabled
    }

  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "Disabled"
    }
  }

  lifecycle {
    ignore_changes = [node_version, resource_labels]
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.daily_maintenance_window_start
    }
  }

  remove_default_node_pool = true

}

data "google_client_config" "default" {}

resource "google_container_node_pool" "default_gke_cluster_nodepool" {
  name              = "${var.cluster_name}-node-pool"
  location          = var.region
  cluster           = google_container_cluster.gke_cluster.name
  node_count        = 1
  version           = var.gke_version
  max_pods_per_node = 64

  node_config {
    disk_size_gb = 100

    spot = false
    machine_type = var.default_nodepool_instance_type

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = 100
    location_policy = "ANY"
  }

  lifecycle {
    ignore_changes = [node_count, autoscaling, node_config[0].labels, version]
  }
}
