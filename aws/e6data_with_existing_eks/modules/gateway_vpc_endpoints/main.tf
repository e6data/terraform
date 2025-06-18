resource "aws_vpc_endpoint" "endpoint" {
  vpc_id         = var.vpc_id
  service_name      = var.service_name
  vpc_endpoint_type = var.vpc_endpoint_type

   tags = {
    Name = "${var.name}-privatelink-endpoint"
  }
}