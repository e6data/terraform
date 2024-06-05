module "network" {
  source = "./modules/network"

  env = var.app
  region = var.aws_region

  workspace_name = var.workspace_name

  vpc_id              = var.vpc_id
  excluded_az         = var.excluded_az
}
