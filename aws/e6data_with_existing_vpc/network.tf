# Create a network infrastructure for the application, including VPC and associated settings
module "network" {
  source = "./modules/network"

  env    = var.app
  region = var.aws_region

  workspace_name = var.workspace_name

  vpc_id      = var.vpc_id
  excluded_az = var.excluded_az
  private_subnet_index = var.private_subnet_index
  public_subnet_index = var.public_subnet_index
}
