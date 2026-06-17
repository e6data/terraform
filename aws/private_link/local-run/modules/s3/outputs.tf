output "name" {
  value = aws_s3_bucket.my_protected_bucket.id
}

output "arn" {
  value = aws_s3_bucket.my_protected_bucket.arn
}


output "domain_name" {
  value = aws_s3_bucket.my_protected_bucket.bucket_domain_name
}