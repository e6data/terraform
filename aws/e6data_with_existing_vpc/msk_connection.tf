resource "aws_msk_vpc_connection" "test" {
  authentication     = "SASL_IAM"
  target_cluster_arn = var.msk_cluster_arn
  vpc_id             = module.network.vpc_id
  client_subnets     = module.network.private_subnets
  security_groups    = [module.security_group.security_group_id]
}