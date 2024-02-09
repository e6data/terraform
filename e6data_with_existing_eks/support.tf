locals {
  e6data_workspace_name = "e6data-workspace-${var.workspace_name}"
  bucket_names_with_full_path = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}/*"]
  bucket_names_with_arn = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}"]

  oidc_tls_suffix = replace(data.aws_eks_cluster.current.identity[0].oidc[0].issuer, "https://", "")

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

data "aws_eks_cluster" "current" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "current" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  alias                  = "eks_e6data"
  host                   = data.aws_eks_cluster.current.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.current.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    command     = var.aws_command_line_path
  }
}

provider "helm" {
  alias                    = "eks_e6data"
  kubernetes {
    host                   = data.aws_eks_cluster.current.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.current.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
      command     = var.aws_command_line_path
    }
  }
}