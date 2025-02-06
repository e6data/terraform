output "oidc_role_arn" {
  value = aws_iam_role.oidc_role.arn
}

# output "service_account_name" {
#   value = kubernetes_service_account_v1.oidc_service_account.metadata.0.name
# }

# output "kubernetes_namespace" {
#   value = kubernetes_service_account_v1.oidc_service_account.metadata.0.namespace
# }

