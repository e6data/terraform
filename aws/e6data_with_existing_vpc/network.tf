# Create a network infrastructure for the application, including VPC and associated settings
module "network" {
  source = "./modules/network"

  env    = var.app
  region = var.aws_region

  workspace_name = var.workspace_name

  vpc_id           = var.vpc_id
  subnet_tag_key   = var.subnet_tag_key
  subnet_tag_value = var.subnet_tag_value
}
