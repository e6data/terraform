# data "tls_certificate" "oidc_tls" {
#   url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
#   verify_chain  = false
# }

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["test"]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}
