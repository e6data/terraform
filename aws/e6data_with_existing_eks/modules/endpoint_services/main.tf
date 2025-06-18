terraform {
    required_providers {
        helm = {
            source = "hashicorp/helm"
        }
        kubernetes = {
            source = "hashicorp/kubernetes"
        }
    }
}

resource "tls_private_key" "kube_api_proxy" {
    algorithm = "RSA"
    rsa_bits  = 2048
}

resource "tls_self_signed_cert" "kube_api_proxy" {
    private_key_pem = tls_private_key.kube_api_proxy.private_key_pem

    subject {
        common_name = var.nameOverride
    }

    validity_period_hours = 8760 
    is_ca_certificate     = false

    allowed_uses = [
        "key_encipherment",
        "digital_signature",
        "server_auth",
    ]
}

resource "helm_release" "kube_api_proxy" {
    name       = "kube-api-proxy2"
    namespace  = "kube-system"
    chart      = "${path.module}/../helm_charts"

    create_namespace = false

    set {
        name  = "nameOverride"
        value = var.nameOverride
    }

    set {
        name  = "replicaCount"
        value = 1
    }

    set {
        name  = "image.repository"
        value = var.nginx_image_repository
    }

    set {
        name  = "image.tag"
        value = var.nginx_image_tag
    }

    set {
        name  = "image.pullPolicy"
        value = "IfNotPresent"
    }

    set {
        name  = "tlsCrt"
        value = base64encode(tls_self_signed_cert.kube_api_proxy.cert_pem)
    }

    set {
        name  = "tlsKey"
        value = base64encode(tls_private_key.kube_api_proxy.private_key_pem)
    }

    set {
        name  = "service.port"
        value = 443
    }

    set {
        name  = "tolerations[0].key"
        value = var.tolerations[0].key
    }

    set {
        name  = "tolerations[0].operator"
        value = var.tolerations[0].operator
    }

    set {
        name  = "tolerations[0].value"
        value = var.tolerations[0].value
    }

    set {
        name  = "tolerations[0].effect"
        value = "NoSchedule"
    }
}
resource "kubernetes_service_v1" "kube_api_proxy" {
    metadata {
        name      = "${var.nameOverride}-svc"
        namespace = "kube-system"
        annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-internal"    = "true"
            "service.beta.kubernetes.io/aws-load-balancer-nlb-target-type" = "ip"
            "service.beta.kubernetes.io/aws-load-balancer-type"        = "nlb"
        }
    }

    spec {
        type = "LoadBalancer"

        selector = {
            "component" = "${var.nameOverride}"
            "app"       = "e6data"
        }

        port {
            port        = 443
            target_port = 443
            protocol    = "TCP"
        }

        load_balancer_class = "service.k8s.aws/nlb"
    }
    wait_for_load_balancer = true

    depends_on = [helm_release.kube_api_proxy]
}

data "aws_lb" "kube_api_proxy" {
    tags = {
        "service.k8s.aws/stack" = "kube-system/${var.nameOverride}-svc",
        "elbv2.k8s.aws/cluster" = var.eks_cluster_name,
        "app"                   = "e6data"
    }

    depends_on = [ kubernetes_service_v1.kube_api_proxy ]
}

resource "aws_vpc_endpoint_service" "eks_endpoint_service" {
    acceptance_required        = true
    allowed_principals         = var.allowed_principals
    supported_ip_address_types = ["ipv4"]
    network_load_balancer_arns = [data.aws_lb.kube_api_proxy.arn]

    tags = {
        Name = "${var.nameOverride}-endpoint-service"
    }

    depends_on = [kubernetes_service_v1.kube_api_proxy]
}