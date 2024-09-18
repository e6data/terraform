data "aws_caller_identity" "current" {
}

data "aws_eks_cluster" "current" {
  name = var.eks_cluster_name
}

locals {
  is_assumed_role = regex("assumed-role", data.aws_caller_identity.current.arn) != ""
  role_name       = split("/", data.aws_caller_identity.current.arn)[1]
  role_arn        = local.is_assumed_role ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.role_name}" : data.aws_caller_identity.current.arn
}

resource "aws_eks_access_entry" "aws_auth" {
  cluster_name  = data.aws_eks_cluster.current.name
  principal_arn = var.cross_account_role_arn
  type          = "STANDARD"
  user_name     = "e6data-${var.workspace_name}-user"
}

resource "aws_eks_access_entry" "tf_runner" {
  cluster_name  = data.aws_eks_cluster.current.name
  principal_arn = local.role_arn
  type          = "STANDARD"
  user_name     = "${var.workspace_name}-terraform-user"
}

resource "aws_eks_access_policy_association" "tf_runner_auth_policy" {
  cluster_name  = data.aws_eks_cluster.current.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = local.role_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.tf_runner]
}