data "aws_caller_identity" "current" {
}

resource "aws_eks_access_entry" "aws_auth" {
  cluster_name  = var.eks_cluster_name
  principal_arn = var.cross_account_role_arn
  type          = "STANDARD"
  user_name     = "e6data-${var.workspace_name}-user"
}

resource "aws_eks_access_entry" "tf_runner" {
  cluster_name  = var.eks_cluster_name
  principal_arn = var.principal_arn
  type          = "STANDARD"
  user_name     = "${var.workspace_name}-terraform-user"
}

resource "aws_eks_access_policy_association" "tf_runner_auth_policy" {
  cluster_name  = var.eks_cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.principal_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.tf_runner]
}