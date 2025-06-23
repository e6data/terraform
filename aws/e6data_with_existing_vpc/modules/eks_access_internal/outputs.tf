output "endpoint_service_name" {
  value = one(module.eks_private_link.*.endpoint_service_name)
}