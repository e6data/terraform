module "network" {
  source = "./modules/network"

  env = var.app

  workspace_name = var.workspace_name

  cidr_block          = var.cidr_block
  excluded_az         = var.excluded_az
}
