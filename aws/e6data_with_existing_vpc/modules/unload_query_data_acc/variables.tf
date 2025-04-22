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

variable "bucket_names" {
  type        = list(string)
  description = "List of bucket names for unload"
}
