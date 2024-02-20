module "network" {
    source = "./modules/network"

    vpc_name = var.vpc_name
    workspace_name = var.workspace_name
    gcp_region = var.gcp_region

    gke_subnet_ip_cidr_range = var.gke_subnet_ip_cidr_range
    vpc_flow_logs_config = var.vpc_flow_logs_config

    cloud_nat_ports_per_vm = var.cloud_nat_ports_per_vm
    tcp_transitory_idle_timeout_sec  = var.cloud_nat_ports_per_vm
    cloud_nat_log_config  = var.cloud_nat_log_config
}