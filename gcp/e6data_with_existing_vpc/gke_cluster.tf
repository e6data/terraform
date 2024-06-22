provider "kubernetes" {
  alias = "gke_e6data"

  host                   = "https://${module.gke_e6data.gke_cluster_endpoint}"
  token                  = module.gke_e6data.google_client_config_access_token
  cluster_ca_certificate = base64decode(module.gke_e6data.gke_cluster_cluster_ca_certificate)
}

provider "helm" {
  alias = "gke_e6data"
  kubernetes {
    host                   = "https://${module.gke_e6data.gke_cluster_endpoint}"
    token                  = module.gke_e6data.google_client_config_access_token
    cluster_ca_certificate = base64decode(module.gke_e6data.gke_cluster_cluster_ca_certificate)
  }
}

module "gke_e6data" {
  source       = "./modules/gke_cluster"
  cluster_name = var.cluster_name
  region       = var.gcp_region
  network      = module.network.network_self_link
  subnetwork   = module.network.subnetwork_self_link
  gke_version  = var.gke_version

  initial_node_count = var.gke_e6data_initial_node_count

  master_ipv4_cidr_block = var.gke_e6data_master_ipv4_cidr_block

  gke_encryption_state = var.gke_encryption_state
  cost_labels          = var.cost_labels
  deletion_protection  = var.deletion_protection
  authorized_networks  = var.authorized_networks

}