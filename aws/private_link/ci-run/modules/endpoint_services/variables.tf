variable "eks_cluster_name" {
    type = string
}

variable "allowed_principals" {
    type = list(string)
}

variable "nameOverride" {
    type    = string
    default = "kube-api-proxy"
}

variable "network_load_balancer_arn" {
    type = string
    description = "ARN of the Network Load Balancer to use for the endpoint service kube api proxy"
}