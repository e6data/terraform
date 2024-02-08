## Private & Regional Cluster
resource "google_container_cluster" "gke_cluster" {
  /* provider           = "google-beta" */

  name               = var.cluster_name
  location           = var.region
  /* node_version       = var.gke_version */
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

  resource_labels = {
    environment = var.environment
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    dns_cache_config {
      enabled = var.dns_cache_enabled
    }

  }

  # Support to encrypt the etcd data in GKE cluster
  database_encryption {
    state    = var.gke_encryption_state
    key_name = var.gke_encryption_key
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
