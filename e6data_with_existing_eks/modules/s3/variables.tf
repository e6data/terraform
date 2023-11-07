variable "bucket_name" {
  type        = string
  description = "Name of S3 bucket"
}

variable "cost_tags" {
  type = map(string)
  description = "Tags for isolation and cost management"
}