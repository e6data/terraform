output "eks_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_certificate_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_oidc_tls" {
  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

output "oidc_arn" {
  description = "arn of oidc for other service accounts to refer to"
  value       = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.eks.name
}

output "cluster_version" {
  description = "EKS Cluster Version"
  value       = aws_eks_cluster.eks.version
}

output "eks_cluster_arn" {
  description = "EKS Cluster arn"
  value       = aws_eks_cluster.eks.arn
}

output "cluster_primary_security_group_id" {
  description = "EKS Cluster primary security group"
  value       = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}