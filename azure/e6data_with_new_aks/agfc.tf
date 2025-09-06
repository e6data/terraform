# Create Application Gateway for Containers resource using Kubernetes manifest
resource "kubernetes_manifest" "application_load_balancer" {
  provider = kubernetes.e6data
  count    = var.agfc_enabled ? 1 : 0

  manifest = {
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancer"
    metadata = {
      name      = var.application_gateway_name
      namespace = var.kubernetes_namespace
    }
    spec = {
      associations = [
        module.network.alb_subnet_id
      ]
    }
  }
  
  depends_on = [
    module.aks_e6data,
    helm_release.alb_controller,
    azurerm_role_assignment.alb_identity_subnet_join,
    azurerm_role_assignment.alb_identity_agfc_config_manager
  ]
}

# # Wait for the Application Gateway for Containers to be ready
# resource "time_sleep" "wait_for_agfc" {
#   count = var.agfc_enabled ? 1 : 0

#   create_duration = "120s"
  
#   depends_on = [kubernetes_manifest.application_load_balancer]
# }


# # Create internal Application Gateway for Containers resource
# resource "kubernetes_manifest" "application_load_balancer_internal" {
#   count = var.agfc_enabled && var.agfc_internal_enabled ? 1 : 0

#   manifest = {
#     apiVersion = "alb.networking.azure.io/v1"
#     kind       = "ApplicationLoadBalancer"
#     metadata = {
#       name      = var.application_gateway_internal_name
#       namespace = var.kubernetes_namespace
#     }
#     spec = {
#       associations = [
#         module.network.alb_internal_subnet_id
#       ]
#     }
#   }

#   depends_on = [
#     helm_release.alb_controller,
#     azurerm_role_assignment.alb_identity_internal_subnet_join,
#     azurerm_role_assignment.alb_identity_agfc_config_manager
#   ]
# }

# Wait for the internal Application Gateway for Containers to be ready
# resource "time_sleep" "wait_for_internal_agfc" {
#   count = var.agfc_enabled && var.agfc_internal_enabled ? 1 : 0

#   create_duration = "120s"
  
#   depends_on = [kubernetes_manifest.application_load_balancer_internal]
# }

# Get the internal Application Gateway for Containers resource details
# data "kubernetes_resource" "alb_internal_status" {
#   count = var.agfc_enabled && var.agfc_internal_enabled ? 1 : 0

#   api_version = "alb.networking.azure.io/v1"
#   kind        = "ApplicationLoadBalancer"

#   metadata {
#     name      = var.application_gateway_internal_name
#     namespace = var.kubernetes_namespace
#   }

#   depends_on = [time_sleep.wait_for_internal_agfc]
# }