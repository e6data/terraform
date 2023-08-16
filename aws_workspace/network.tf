module "network" {
  source = "./modules/network"

  env = var.app

  cidr_block          = var.cidr_block
  excluded_az         = var.excluded_az
}
