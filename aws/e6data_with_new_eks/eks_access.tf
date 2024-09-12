resource "aws_eks_access_entry" "aws_auth" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.e6data_cross_account_role.arn
  type          = "STANDARD"
  user_name     = "e6data-${var.workspace_name}-user"
  depends_on    = [module.eks]
}

# resource "aws_eks_access_policy_association" "aws_auth_policy" {
#   cluster_name  = module.eks.cluster_name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#   principal_arn = aws_iam_role.e6data_cross_account_role.arn

#   access_scope {
#     type = "cluster"
#   }

#   depends_on = [aws_eks_access_entry.aws_auth, module.eks]
# }

resource "aws_eks_access_entry" "aws_karpenter_auth" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.karpenter_node_role.arn
  type          = "STANDARD"
  user_name     = "e6data-${var.workspace_name}-user"
  depends_on    = [module.eks]
}

# resource "aws_eks_access_policy_association" "aws_karpenter_auth_policy" {
#   cluster_name  = module.eks.cluster_name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#   principal_arn = aws_iam_role.karpenter_node_role.arn

#   access_scope {
#     type = "cluster"
#   }

#   depends_on = [aws_eks_access_entry.aws_karpenter_auth, module.eks]
# }