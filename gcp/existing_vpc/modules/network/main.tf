data "google_compute_network" "network" {
  name = var.vpc_name
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "e6data-${var.workspace_name}-subnetwork"
  ip_cidr_range = var.gke_subnet_ip_cidr_range
  region        = var.gcp_region
  network       = data.google_compute_network.network.name

  private_ip_google_access = true

  dynamic "log_config" {
    for_each = var.vpc_flow_logs_config
    content {
      aggregation_interval = log_config.value["aggregation_interval"]
      flow_sampling        = log_config.value["flow_sampling"]
      metadata             = log_config.value["metadata"]
    }
  }
}

# # By default the nodes in a private GKE cluster do not have internet access and
# # hence a Cloud NAT is provisioned to access the internet
# # https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters#pulling_images
resource "google_compute_router" "router" {
  name    = "e6data-${var.workspace_name}-router"
  region  = var.gcp_region
  network = data.google_compute_network.network.name
}

resource "google_compute_router_nat" "nat" {
  name                               = "e6data-${var.workspace_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  min_ports_per_vm                   = var.cloud_nat_ports_per_vm
  tcp_transitory_idle_timeout_sec    = var.tcp_transitory_idle_timeout_sec

  dynamic "log_config" {
    for_each = var.cloud_nat_log_config == null ? [] : list(var.cloud_nat_log_config)

    content {
      enable = var.cloud_nat_log_config.enable
      filter = var.cloud_nat_log_config.filter
    }
  }

}

data "google_netblock_ip_ranges" "netblock" {}

data "google_compute_zones" "available_zones_primary" {
  region = var.gcp_region
}