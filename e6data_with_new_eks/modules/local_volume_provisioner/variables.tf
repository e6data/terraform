variable "workspace_name" {
  description = "Name of e6data workspace to be created"
  type        = string
}

variable "local_volume_provisioner_release_version" {
  type        = string
  description = "Version of the local volume provisioner release"
  default     = "2.0.0"
}

variable "namespace" {
  type        = string
  description = "Namespace to deploy the local volume provisioner"
}