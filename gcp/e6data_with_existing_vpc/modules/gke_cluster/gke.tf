## Private & Regional Cluster
resource "google_container_cluster" "gke_cluster" {

  name                = "e6data-${var.cluster_name}"
  location            = var.region
  min_master_version  = var.gke_version
  monitoring_service  = "monitoring.googleapis.com/kubernetes"
  logging_service     = "logging.googleapis.com/kubernetes"
  network             = var.network
  subnetwork          = var.subnetwork
  initial_node_count  = var.initial_node_count
  deletion_protection = var.deletion_protection

  vertical_pod_autoscaling {
    enabled = false
  }

  # Workloads are being configured to utilize the Workload Identity provider instead of directly relying on the service account of the worker node.
  # https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity?source=post_page-----d11a230f8e49--------------------------------
  workload_identity_config {
    workload_pool = "${data.google_client_config.default.project}.svc.id.goog"
  }

  database_encryption {
    state    = var.gke_encryption_state
    key_name = var.gke_encryption_key
  }

  private_cluster_config {
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    enable_private_endpoint = false
  }

  ip_allocation_policy {
    cluster_secondary_range_name = "e6data-${var.workspace_name}-podrange"
    services_secondary_range_name = "e6data-${var.workspace_name}-servicerange"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    dns_cache_config {
      enabled = var.dns_cache_enabled
    }

  }

  resource_labels = var.cost_labels

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.authorized_networks
      content {
        cidr_block   = cidr_blocks.key
        display_name = cidr_blocks.value
      }
    }
  }

  lifecycle {
    ignore_changes = [node_version, resource_labels]
  }

  remove_default_node_pool = true

}

data "google_client_config" "default" {}