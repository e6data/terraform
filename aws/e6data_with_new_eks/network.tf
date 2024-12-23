# Create a network infrastructure for the application, including VPC and associated settings
module "network" {
  source = "./modules/network"

  env    = var.app
  region = var.aws_region

  workspace_name = var.workspace_name

  cidr_block  = var.cidr_block
  excluded_az = var.excluded_az
}
