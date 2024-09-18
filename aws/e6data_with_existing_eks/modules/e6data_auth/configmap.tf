
data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "current" {
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

resource "kubernetes_config_map_v1_data" "aws_auth_update" {
  count = var.authentication_mode == "CONFIG_MAP" ? 1 : 0

  provider = kubernetes.eks_e6data
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = local.map3 # Ensure you define local.map3 appropriately in this module.

  force = true

  lifecycle {
    ignore_changes = [data]
  }
}

resource "aws_eks_access_entry" "aws_auth" {
  count = var.authentication_mode == "API_AND_CONFIG_MAP" ? 1 : 0

  cluster_name  = data.aws_eks_cluster.current.name
  principal_arn = var.cross_account_role_arn
  type          = "STANDARD"
  user_name     = "e6data-${var.workspace_name}-user"
}

resource "aws_eks_access_entry" "tf_runner" {
  count = var.authentication_mode == "API_AND_CONFIG_MAP" ? 1 : 0

  cluster_name  = data.aws_eks_cluster.current.name
  principal_arn = local.role_arn # Ensure local.role_arn is defined properly.

}