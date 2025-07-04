# Define an IAM policy document for allowing OIDC-based role assumption by Kubernetes service accounts
data "aws_iam_policy_document" "oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_tls_suffix}:sub"
      values   = ["system:serviceaccount:${var.kubernetes_namespace}:${var.workspace_name}"]
    }

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_tls_suffix}"]
      type        = "Federated"
    }
  }
}

data "aws_iam_policy_document" "system_tables_policy" {
   statement {
    sid    = "AssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]
    resources = ["arn:aws:iam::${local.cross_account_id}:role/e6-system-tables-*"]
  }

  statement {
    sid    = "TagSession"
    effect = "Allow"

    actions = [
      "sts:TagSession"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "engine_iam_glue_s3readAccess_doc" {
  statement {
    sid    = "glueReadOnlyAccess"
    effect = "Allow"

    actions = [
      "glue:GetDatabase*",
      "glue:GetTable*",
      "glue:GetPartitions",
      "glue:DeleteTable",
      "glue:CreateTable",
      "glue:UpdateTable"
    ]
    resources = ["*"]
  }

  statement {
    sid       = "ListBucket"
    actions   = ["s3:ListBucket"]
    resources = local.bucket_names_with_arn
  }

  statement {
    sid    = "ReadeE6dataBucket"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:ListObjects"
    ]
    resources = local.bucket_names_with_full_path
  }
}

# Create an IAM policy that grants read access to S3 buckets and the Glue catalog
resource "aws_iam_policy" "e6data_engine_s3_glue_policy" {
  name        = "${local.e6data_workspace_name}-engine-s3-glue-${random_string.random.result}"
  description = "Allows read access for s3 buckets and glue catalog"
  policy      = data.aws_iam_policy_document.engine_iam_glue_s3readAccess_doc.json
}

resource "aws_iam_policy" "e6data_engine_system_tables_policy" {
  name        = "${local.e6data_workspace_name}-engine-system-tables-${random_string.random.result}"
  description = "Allows assume the role for system tables"
  policy      = data.aws_iam_policy_document.system_tables_policy.json
}


# Create an IAM role for the engine, allowing it to assume the role with specified policies attached
resource "aws_iam_role" "e6data_engine_role" {
  name                = "${local.e6data_workspace_name}-engine-role-${random_string.random.result}"
  assume_role_policy  = data.aws_iam_policy_document.oidc_assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.e6data_engine_s3_glue_policy.arn, aws_iam_policy.e6data_s3_read_write_policy.arn, aws_iam_policy.e6data_engine_system_tables_policy.arn]
}