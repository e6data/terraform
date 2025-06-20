locals {
  short_workspace_name = substr(var.workspace_name, 0, 5)
  assumed_role         = can(regex("assumed-role", data.aws_caller_identity.current.arn))
  role_name            = split("/", data.aws_caller_identity.current.arn)[1]
  role_arn             = local.assumed_role ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.role_name}" : data.aws_caller_identity.current.arn
  e6data_workspace_name       = "e6data-workspace-${local.short_workspace_name}"
  bucket_names_with_full_path = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}/*"]
  bucket_names_with_arn       = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}"]

  e6data_nodepool_name  = "e6data-nodepool-${local.short_workspace_name}-${random_string.random.result}"
  e6data_nodeclass_name = "e6data-nodeclass-${local.short_workspace_name}-${random_string.random.result}"

  oidc_tls_suffix = replace(module.eks.eks_oidc_tls, "https://", "")

  helm_values_file = yamlencode({
    cloud = {
      type               = "AWS"
      oidc_value         = aws_iam_role.e6data_engine_role.arn
      control_plane_user = ["e6data-${var.workspace_name}-user"]
      debug_namespaces   = var.debug_namespaces
    }
  })
}

resource "random_string" "random" {
  length  = 5
  special = false
  lower   = true
  upper   = false
}

data "aws_caller_identity" "current" {
}