output "eks_cluster_name" {
  value = one(module.eks.*.cluster_name)
}

output "eks_cluster_version" {
  value = one(module.eks.*.cluster_version)
}

output "eks_endpoint" {
  value = one(module.eks.*.eks_endpoint)
}