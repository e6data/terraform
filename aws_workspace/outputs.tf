output "e6data_workspace_name" {
  value = var.workspace_name
}

output "workspace_s3_bucket_name" {
  value = module.e6data_s3_bucket.name
}

output "region" {
  value = var.aws_region
}

output "eks_nodegroup_name" {
  value = aws_eks_node_group.workspace_node_group.node_group_name
}

output "cross_account_role_arn" {
  value = aws_iam_role.e6data_cross_account_role.arn
}

output "kubernetes_cluster_name" {
  value = var.cluster_name
}

output "kubernetes_namespace_for_e6data_workspace" {
  value = var.kubernetes_namespace
}

output "eks_nodegroup_max_instances" {
  value = var.max_instances_in_eks_nodegroup
}