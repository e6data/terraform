
resource "helm_release" "nginx_ingress" {
  provider = helm.e6data

  name       = "ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = var.nginx_ingress_controller_version
  namespace  = var.nginx_ingress_controller_namespace

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
}

resource "kubernetes_ingress_v1" "dummy" {
  provider = kubernetes.e6data
  metadata {
    name      = "dummy-ingress"
    namespace = var.kubernetes_namespace
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "dummy.com"

      http {
        path {
          path = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "dummy-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}