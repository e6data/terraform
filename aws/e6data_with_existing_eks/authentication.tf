locals {
  authentication_mode = data.aws_eks_cluster.current.authentication_mode
}

module "e6data_auth" {
  source                  = "./modules/e6data_auth"
  workspace_name          = var.workspace_name
  eks_cluster_name        = var.eks_cluster_name
  karpenter_node_role_arn = aws_iam_role.karpenter_node_role.arn
  cross_account_role_arn  = aws_iam_role.e6data_cross_account_role.arn
  aws_command_line_path   = var.aws_command_line_path

  authentication_mode = local.authentication_mode
}