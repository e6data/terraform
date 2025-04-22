locals {
  policy_name = "${var.identifier}-${var.query_type}-query-policy" 
}

resource "aws_iam_policy" "query_policy" {
  name        = local.policy_name
  description = "IAM policy for ${var.query_type} query"
  policy      = data.aws_iam_policy_document.cross_acc_query.json
}

data "aws_iam_policy_document" "cross_acc_query" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      var.cross_acc_query_role_arn
    ]

    dynamic "condition" {
      for_each = var.external_id != "" ? [1] : []
      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = [var.external_id]
      }
    }
  }

  statement {
    actions = ["sts:TagSession"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "query_policy_attachment" {
  policy_arn = aws_iam_policy.query_policy.arn
  role       = var.engine_role_name
}