locals {
    bucket_names_with_full_path = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}/*"]
    bucket_names_with_arn       = [for bucket_name in var.bucket_names : "arn:aws:s3:::${bucket_name}"]
}

resource "aws_iam_role" "cross_query_role" {
    name = "${var.identifier}-cross-account-query-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = concat(
        [
            {
            Effect = "Allow",
            Principal = {
                AWS = var.engine_role_arn
            },
            Action = "sts:AssumeRole"
            }
        ],
        var.external_id != "" ? [
            {
            Effect = "Allow",
            Principal = {
                AWS = var.engine_role_arn
            },
            Action = "sts:AssumeRole",
            Condition = {
                StringEquals = {
                "sts:ExternalId" = var.external_id
                }
            }
            }
        ] : [],
        [
            {
            Effect = "Allow",
            Principal = {
                AWS = var.engine_role_arn
            },
            Action = "sts:TagSession"
            }
        ]
        )
    })
}


resource "aws_iam_policy" "glue_policy" {
    name        = "${var.identifier}-glue-policy"
    description = "IAM policy for Glue access"
    policy      = data.aws_iam_policy_document.glue_policy.json
}

data "aws_iam_policy_document" "glue_policy" {
    statement {
        actions = [
            "glue:GetDatabase*",
            "glue:GetTable*",
            "glue:GetPartitions",
            "glue:DeleteTable",
            "glue:CreateTable",
            "glue:UpdateTable"
        ]
        resources = [
            "arn:aws:glue:${var.region}:${var.account_id}:catalog",
            "arn:aws:glue:${var.region}:${var.account_id}:database/*",
            "arn:aws:glue:${var.region}:${var.account_id}:table/*"
        ]
    }
}

resource "aws_iam_role_policy_attachment" "cross_acc_query_glue_policy_attachment" {
    role       = aws_iam_role.cross_query_role.name
    policy_arn = aws_iam_policy.glue_policy.arn
}

resource "aws_iam_policy" "s3_access" {
    name        = "${var.identifier}-s3-access-policy"
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

resource "aws_iam_role_policy_attachment" "cross_acc_query_s3_policy_attachment" {
    role       = aws_iam_role.cross_query_role.name
    policy_arn = aws_iam_policy.s3_access.arn
}