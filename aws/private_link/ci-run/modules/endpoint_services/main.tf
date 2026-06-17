resource "aws_vpc_endpoint_service" "eks_endpoint_service" {
    acceptance_required        = true
    allowed_principals         = var.allowed_principals
    supported_ip_address_types = ["ipv4"]
    network_load_balancer_arns = [var.network_load_balancer_arn]

    tags = {
        Name = "${var.nameOverride}-endpoint-service"
    }
}