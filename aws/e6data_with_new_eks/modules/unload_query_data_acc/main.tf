locals {
    bucket_names_with_full_path = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}/*"]
    bucket_names_with_arn       = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}"]
}

resource "aws_iam_role" "unload_role" {
    name = "${var.identifier}-unload-query-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = [
            "sts:AssumeRole",
            ]
            Effect = "Allow"
            Principal = {
            AWS = [var.engine_role_arn]
            }
            Condition = var.external_id != "" ? {
            StringEquals = {
                "sts:ExternalId" = var.external_id
            }
            } : null
        },
        {
            Action = [
            "sts:TagSession"
            ]
            Effect = "Allow"
            Principal = {
            AWS = [var.engine_role_arn]
            }
            Resource = "*"
        }
        ]
    })
}

resource "aws_iam_policy" "s3_access" {
    name        = "${var.identifier}-unload-s3-access-policy"
    description = "IAM policy for S3 access"
    policy      = data.aws_iam_policy_document.s3_access.json
} 

data "aws_iam_policy_document" "s3_access" {
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