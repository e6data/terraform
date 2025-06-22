# data "tls_certificate" "oidc_tls" {
#   url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
#   verify_chain  = false
# }

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0f419e9f5"]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}
