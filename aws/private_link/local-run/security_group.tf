module "security_group" {
  source        = "./modules/security_group"
  sec_grp_name  = "${local.e6data_workspace_name}-${random_string.random.result}"
  vpc_id        = module.network.vpc_id
  cidr_block    = [module.network.vpc_cidr]
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules

  additional_ingress_rules = var.additional_ingress_rules
  additional_egress_rules  = var.additional_egress_rules

  depends_on = [module.network]
}