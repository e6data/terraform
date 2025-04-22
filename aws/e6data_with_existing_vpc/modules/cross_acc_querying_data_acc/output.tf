output "cross_query_role_arn" {
    value = aws_iam_role.cross_query_role.arn
    description = "ARN of the cross-account query IAM role"
}
