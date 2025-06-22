data "tls_certificate" "oidc_tls" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
  verify_chain  = false
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc_tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}
