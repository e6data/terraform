resource "aws_eks_access_entry" "aws_auth" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.e6data_cross_account_role.arn
  type          = "STANDARD"
  user_name     = "e6data-${var.workspace_name}-user"
  depends_on    = [module.eks]
}

resource "aws_eks_access_entry" "tf_runner" {
  cluster_name  = module.eks.cluster_name
  principal_arn = local.role_arn
  type          = "STANDARD"
  user_name     = "terraform-user"
  depends_on    = [module.eks]
}

resource "aws_eks_access_policy_association" "tf_runner_auth_policy" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = local.role_arn

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.tf_runner, module.eks]
}