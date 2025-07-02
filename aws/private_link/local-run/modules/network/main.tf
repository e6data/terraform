# Get object aws_vpc by vpc_id
data "aws_vpc" "vpc" {
  id = var.vpc_id
}