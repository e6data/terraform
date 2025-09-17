
# Deploy ALB Controller using Helm
resource "helm_release" "alb_controller" {
  provider = helm.e6data
  count    = var.agfc_enabled && var.alb_controller_enabled ? 1 : 0

  name       = "alb-controller"
  repository = "oci://mcr.microsoft.com/application-lb/charts"
  chart      = "alb-controller"
  version    = var.alb_controller_version
  namespace  = var.alb_controller_helm_namespace

  # Create namespace if specified
  create_namespace = var.alb_controller_helm_create_namespace

  # Set the controller namespace and pod identity
  set {
    name  = "albController.namespace"
    value = var.alb_controller_namespace
  }

  set {
    name  = "albController.podIdentity.clientID"
    value = azurerm_user_assigned_identity.alb_identity[0].client_id
  }

  # Configure replica count
  set {
    name  = "replicaCount"
    value = var.alb_controller_replica_count
  }

  # Configure resource limits
  set {
    name  = "resources.limits.cpu"
    value = var.alb_controller_resource_limits.cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.alb_controller_resource_limits.memory
  }

  # Configure resource requests
  set {
    name  = "resources.requests.cpu"
    value = var.alb_controller_resource_requests.cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.alb_controller_resource_requests.memory
  }

  # Configure log level
  set {
    name  = "albController.logLevel"
    value = var.alb_controller_log_level
  }

  # Configure service account name
  set {
    name  = "serviceAccount.name"
    value = var.alb_controller_service_account_name
  }

  # Configure node selector if provided
  dynamic "set" {
    for_each = var.alb_controller_node_selector
    content {
      name  = "nodeSelector.${set.key}"
      value = set.value
    }
  }

  # Configure tolerations if provided
  dynamic "set" {
    for_each = var.alb_controller_tolerations
    content {
      name  = "tolerations[${set.key}].${set.value.key}"
      value = set.value.value
    }
  }

  # Wait for the deployment to be ready
  wait = true
  wait_for_jobs = true
  timeout = 600

  depends_on = [
    azurerm_user_assigned_identity.alb_identity,
    azurerm_federated_identity_credential.alb_identity,
    azurerm_role_assignment.alb_identity_node_rg_reader,
    azurerm_role_assignment.alb_identity_network_contributor,
    azurerm_role_assignment.alb_identity_agfc_config_manager,
    azurerm_role_assignment.alb_identity_subnet_join,
    azurerm_role_assignment.alb_identity_internal_subnet_join
  ]
}