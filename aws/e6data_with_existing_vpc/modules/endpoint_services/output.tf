output "endpoint_service_name" {
  value = aws_vpc_endpoint_service.eks_endpoint_service.service_name
}