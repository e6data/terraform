data "aws_caller_identity" "current" {
}

data "aws_eks_cluster" "current" {
  name = var.eks_cluster_name
}

resource "aws_eks_access_entry" "aws_auth" {
  cluster_name  = data.aws_eks_cluster.current.name
  principal_arn = var.cross_account_role_arn
  type          = "STANDARD"
  user_name     = "e6data-${var.workspace_name}-user"
}
