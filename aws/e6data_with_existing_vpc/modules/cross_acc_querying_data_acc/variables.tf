variable "identifier" {
  description = "Identifier for the module"
  type        = string
}

variable "engine_role_arn" {
  description = "ARN of the e6data engine role"
  type        = string
}

variable "external_id" {
  description = "External ID for cross-account query"
  type        = string
  default     = ""
}

variable "account_id" {
  description = "Account ID for cross-account query"
  type        = string
}

variable "region" {
  description = "AWS region for cross-account query"
  type        = string
}

variable "bucket_names" {
  type        = list(string)
  description = "List of bucket names to be queried in the cross account"
}
