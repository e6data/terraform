variable "eks_cluster_name" {
    type = string
}

variable "allowed_principals" {
    type = list(string)
}

variable "nginx_image_repository" {
    description = "Container image repository for nginx"
}

variable "nginx_image_tag" {
    description = "Container image tag for nginx"
}

variable "tolerations" {
    description = "Tolerations applied to the kube-api-proxy deployment"
    type        = list(object({
        key      = string
        operator = string
        value    = string
    }))
    default = [
        {
            key      = "e6data-workspace-name"
            operator = "Equal"
            value    = "default"
        }
    ]
}

variable "nameOverride" {
    type    = string
    default = "kube-api-proxy"
}