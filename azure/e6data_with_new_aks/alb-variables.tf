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

variable "agfc_subnet_prefix_length" {
  description = "Prefix length for AGFC subnet (must provide at least 250 available IPs - /24 or larger)"
  type        = number
  default     = 8  # This will create a /24 subnet when VNet is /16
}

variable "agfc_subnet_cidr_offset" {
  description = "CIDR offset for AGFC subnet within the VNet"
  type        = number
  default     = 2  # Use third subnet block (after AKS and ACI)
}

variable "agfc_internal_enabled" {
  description = "Enable internal Azure Application Gateway for Containers deployment"
  type        = bool
  default     = false
}

variable "agfc_internal_subnet_prefix_length" {
  description = "Prefix length for internal AGFC subnet (must provide at least 250 available IPs - /24 or larger)"
  type        = number
  default     = 8  # This will create a /24 subnet when VNet is /16
}

variable "agfc_internal_subnet_cidr_offset" {
  description = "CIDR offset for internal AGFC subnet within the VNet"
  type        = number
  default     = 3  # Use fourth subnet block (after AKS, ACI, and ALB)
}

variable "application_gateway_name" {
  description = "Name of the Application Gateway for Containers resource"
  type        = string
  default     = "alb-agfc"
}

variable "application_gateway_internal_name" {
  description = "Name of the internal Application Gateway for Containers resource"
  type        = string
  default     = "alb-agfc-internal"
}