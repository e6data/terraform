variable "identifier" {
  description = "Identifier for the module"
  type        = string
}

variable "cross_acc_query_role_arn" {
  description = "ARN of the cross-account query role"
  type        = string
}

variable "external_id" {
  description = "External ID for cross-account query"
  type        = string
  default     = ""
}

variable "engine_role_name" {
  description = "Source account ID for cross-account query"
  type        = string
  default     = ""
}

variable "query_type" {
  description = "Type of query to be executed"
  type        = string
  validation {
    condition = contains(["unload", "cross_acc_query", "system_tables"], var.query_type)
    error_message = "Valid value is one of the following: unload, cross_acc_query"
  }
}

variable "region" {
  description = "AWS region for cross-account query"
  type        = string
}

variable "cross_account_id" {
  description = "Account ID for cross-account query"
  type        = string
}
