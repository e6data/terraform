resource "aws_eks_access_entry" "aws_auth" {
  cluster_name  = data.aws_eks_cluster.current.name
  principal_arn = aws_iam_role.e6data_cross_account_role.arn
  type          = "STANDARD"
  user_name     = "e6data-${var.workspace_name}-user"
}

# resource "aws_eks_access_entry" "tf_runner" {
#   cluster_name  = data.aws_eks_cluster.current.name
#   principal_arn = local.role_arn
#   type          = "STANDARD"
#   user_name     = "${var.workspace_name}-terraform-user"
# }

# resource "aws_eks_access_policy_association" "tf_runner_auth_policy" {
#   cluster_name  = data.aws_eks_cluster.current.name
#   policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#   principal_arn = local.role_arn

#   access_scope {
#     type = "cluster"
#   }

#   depends_on = [aws_eks_access_entry.tf_runner]
# }