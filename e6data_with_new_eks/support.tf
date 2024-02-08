locals {
  e6data_workspace_name = "e6data-workspace-${var.workspace_name}"
  bucket_names_with_full_path = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}/*"]
  bucket_names_with_arn = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}"]

  oidc_tls_suffix = replace(module.eks.eks_oidc_tls, "https://", "")

  helm_values_file =yamlencode({
    cloud = {
      type = "AWS"
      oidc_value = aws_iam_role.e6data_engine_role.arn
      control_plane_user = ["e6data-${var.workspace_name}-user"]
    }
  })
}

data "aws_caller_identity" "current" {
}

# data "aws_eks_cluster" "current" {
#   name = module.eks.cluster_name
# }

data "aws_eks_cluster_auth" "current" {
  name = module.eks.cluster_name
}