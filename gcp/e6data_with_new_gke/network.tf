module "network" {
  source = "./modules/network"

  workspace_name = var.workspace_name
  gcp_region     = var.gcp_region

  gke_subnet_ip_cidr_range = var.gke_subnet_ip_cidr_range
  vpc_flow_logs_config     = var.vpc_flow_logs_config

  cloud_nat_ports_per_vm = var.cloud_nat_ports_per_vm
  cloud_nat_log_config   = var.cloud_nat_log_config
}