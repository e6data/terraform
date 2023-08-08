output "worker_node_arn" {
  value = aws_eks_node_group.eks_worker_node.arn
}

output "eks_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_certificate_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_oidc_tls" {
  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

output "node_role_name" {
  value = aws_iam_role.iam_eks_node_role.name
}

output "node_role_arn" {
  value = aws_iam_role.iam_eks_node_role.arn
}

output "oidc_arn" {
  description = "arn of oidc for other service accounts to refer to"
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "nodegroup_asg_name" {
  description = "Cluster autoscaler tag for autoscaling group instances"
  value = aws_eks_node_group.eks_worker_node.resources[0].autoscaling_groups[0].name
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value = aws_eks_cluster.eks.name
}

output "cluster_version" {
  description = "EKS Cluster Version"
  value = aws_eks_cluster.eks.version
}

output "nodegroup_name" {
  description = "EKS Nodegroup Name"
  value = aws_eks_node_group.eks_worker_node.node_group_name
}


