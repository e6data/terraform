provider "kubernetes" {
  alias                  = "gke_e6data"

  host                   = "https://${module.gke_e6data.gke_cluster_endpoint}"
  token                  = module.gke_e6data.google_client_config_access_token
  cluster_ca_certificate = base64decode(module.gke_e6data.gke_cluster_cluster_ca_certificate)
} 

provider "helm" {
  alias          = "gke_e6data"
  kubernetes {
    host                   = "https://${module.gke_e6data.gke_cluster_endpoint}"
    token                  = module.gke_e6data.google_client_config_access_token
    cluster_ca_certificate = base64decode(module.gke_e6data.gke_cluster_cluster_ca_certificate)
  }
}

module "gke_e6data" {
  source             = "./modules/gke_cluster"
  cluster_name       = var.cluster_name
  region             = var.gcp_region
  network            = module.network.network_self_link
  subnetwork         = module.network.subnetwork_self_link
  gke_version        = var.gke_version
  default_nodepool_instance_type = var.default_nodepool_instance_type

  initial_node_count             = var.gke_e6data_initial_node_count
  daily_maintenance_window_start = var.daily_maintenance_window_start

  master_ipv4_cidr_block        = var.gke_e6data_master_ipv4_cidr_block
  cluster_secondary_range_name  = var.gke_cluster_secondary_range_name
  services_secondary_range_name = var.gke_services_secondary_range_name

  gke_encryption_state = var.gke_encryption_state
  gke_encryption_key   = var.gke_encryption_key

  dns_cache_enabled    = var.gke_dns_cache_enabled

  # oauth_scopes = var.oauth_scopes
  
}