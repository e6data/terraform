# Variables for ALB Controller and AGFC Configuration

variable "agfc_enabled" {
  description = "Enable Azure Application Gateway for Containers deployment"
  type        = bool
  default     = true
}

variable "alb_controller_enabled" {
  description = "Enable ALB Controller deployment via Helm"
  type        = bool
  default     = true
}

variable "alb_controller_namespace" {
  description = "Kubernetes namespace where ALB Controller components will be deployed"
  type        = string
  default     = "azure-alb-system"
}

variable "alb_controller_helm_namespace" {
  description = "Kubernetes namespace for Helm chart deployment"
  type        = string
  default     = "default"
}

variable "alb_controller_create_namespace" {
  description = "Create the ALB Controller namespace if it doesn't exist"
  type        = bool
  default     = true
}

variable "alb_controller_helm_create_namespace" {
  description = "Create the Helm deployment namespace if it doesn't exist"
  type        = bool
  default     = false
}

variable "alb_controller_service_account_name" {
  description = "Service account name for ALB Controller"
  type        = string
  default     = "alb-controller-sa"
}

variable "alb_controller_version" {
  description = "Version of ALB Controller Helm chart"
  type        = string
  default     = "1.7.9"
}

variable "alb_controller_replica_count" {
  description = "Number of replicas for ALB Controller deployment"
  type        = number
  default     = 2
}

variable "alb_controller_resource_limits" {
  description = "Resource limits for ALB Controller pods"
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "500m"
    memory = "512Mi"
  }
}

variable "alb_controller_resource_requests" {
  description = "Resource requests for ALB Controller pods"
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "100m"
    memory = "128Mi"
  }
}

variable "alb_controller_log_level" {
  description = "Log level for ALB Controller (debug, info, warn, error)"
  type        = string
  default     = "info"
}

variable "alb_controller_node_selector" {
  description = "Node selector for ALB Controller pods"
  type        = map(string)
  default     = {}
}

variable "alb_controller_tolerations" {
  description = "Tolerations for ALB Controller pods"
  type        = map(map(string))
  default     = {}
}

variable "agfc_tags" {
  description = "Additional tags to apply to AGFC resources"
  type        = map(string)
  default     = {}
}

variable "alb_subnet_id" {
  description = "The subnet ID for ALB (Application Gateway for Containers). Must be delegated to Microsoft.ServiceNetworking/trafficControllers"
  type        = string
  default     = ""
}

variable "vnet_id" {
  description = "The VNet ID where the AKS cluster is deployed (required for AGFC Network Contributor role)"
  type        = string
  default     = ""
}

variable "application_gateway_name" {
  description = "Name of the Application Gateway for Containers resource"
  type        = string
  default     = "alb-agfc"
}
