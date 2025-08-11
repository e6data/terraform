data "aws_iam_policy_document" "oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.tls_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.kubernetes_namespace}:${var.kubernetes_service_account_name}"]
    }

    principals {
      identifiers = [var.eks_oidc_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "oidc_role" {
  assume_role_policy  = data.aws_iam_policy_document.oidc_assume_role_policy.json
  name                = "${var.oidc_role_name}-oidc-role"
  managed_policy_arns = var.policy_arn
}