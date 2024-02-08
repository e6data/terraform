module "network" {
    source = "./modules/network"

    env = var.app
    component_name = var.component_name
    gcp_region = var.gcp_region

    gke_subnet_ip_cidr_range = var.gke_subnet_ip_cidr_range

    gke_services_secondary_range_name = var.gke_services_secondary_range_name
    gke_services_ipv4_cidr_block = var.gke_services_ipv4_cidr_block

    gke_cluster_secondary_range_name = var.gke_cluster_secondary_range_name
    gke_cluster_ipv4_cidr_block = var.gke_cluster_ipv4_cidr_block

    vpc_flow_logs_config = var.vpc_flow_logs_config

    cloud_nat_ports_per_vm = var.cloud_nat_ports_per_vm
    tcp_transitory_idle_timeout_sec  = var.cloud_nat_ports_per_vm
    cloud_nat_log_config  = var.cloud_nat_log_config
}