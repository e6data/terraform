output "workspace_name" {
  value = var.workspace_name
}

output "region" {
  value = var.aws_region
}

output "workspace_s3_bucket_name" {
  value = module.e6data_s3_bucket.name
}

output "cross_account_role_arn" {
  value = aws_iam_role.e6data_cross_account_role.arn
}

output "sts_external_id" {
  value = var.sts_external_id
}

output "kubernetes_cluster_name" {
  value = var.eks_cluster_name
}

output "kubernetes_namespace" {
  value = var.kubernetes_namespace
}
