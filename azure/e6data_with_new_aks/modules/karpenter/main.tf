

resource "helm_release" "karpenter" {

  name       = "karpenter"
  chart      = "karpenter"
  repository = "oci://mcr.microsoft.com/aks/karpenter/karpenter"
  version    = var.karpenter_version
  namespace  = var.karpenter_namespace
  create_namespace = true

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name  = "controller.env[0].name"
    value = "FEATURE_GATES"
  }

  set {
    name  = "controller.env[0].value"
    value = "Drift=true"
  }

  set {
    name  = "controller.env[1].name"
    value = "LEADER_ELECT"
  }

  set {
    name  = "controller.env[1].value"
    value = "false"
  }

  set {
    name  = "controller.env[2].name"
    value = "CLUSTER_NAME"
  }

  set {
    name  = "controller.env[2].value"
    value = "karpenter"
  }

  set {
    name  = "controller.env[3].name"
    value = "CLUSTER_ENDPOINT"
  }

  set {
    name  = "controller.env[3].value"
    value = "<>:443"
  }

  set {
    name  = "controller.env[4].name"
    value = "KUBELET_BOOTSTRAP_TOKEN"
  }

  set {
    name  = "controller.env[4].value"
    value = "w95cz5.9umj7o49caznaohr"
  }

  set {
    name  = "controller.env[5].name"
    value = "NETWORK_PLUGIN"
  }

  set {
    name  = "controller.env[5].value"
    value = "azure"
  }

  set {
    name  = "controller.env[6].name"
    value = "NETWORK_POLICY"
  }

  set {
    name  = "controller.env[6].value"
    value = ""
  }

  set {
    name  = "controller.env[7].name"
    value = "NODE_IDENTITIES"
  }

  set {
    name  = "controller.env[7].value"
    value = "/subscriptions/<>/resourcegroups/MC_karpenter_karpenter_eastus/providers/Microsoft.ManagedIdentity/userAssignedIdentities/karpenter-agentpool"
  }

  set {
    name  = "controller.env[8].name"
    value = "ARM_SUBSCRIPTION_ID"
  }

  set {
    name  = "controller.env[8].value"
    value = "<>"
  }

  set {
    name  = "controller.env[9].name"
    value = "LOCATION"
  }

  set {
    name  = "controller.env[9].value"
    value = "eastus"
  }

  set {
    name  = "controller.env[10].name"
    value = "VNET_SUBNET_ID"
  }

  set {
    name  = "controller.env[10].value"
    value = "/subscriptions/<>/resourceGroups/MC_karpenter_karpenter_eastus/providers/Microsoft.Network/virtualNetworks/aks-vnet-96206985/subnets/aks-subnet"
  }

  set {
    name  = "controller.env[11].name"
    value = "SSH_PUBLIC_KEY"
  }

  set {
    name  = "controller.env[11].value"
    value = "ssh-rsa <>"
  }

  set {
    name  = "controller.env[12].name"
    value = "ARM_USE_CREDENTIAL_FROM_ENVIRONMENT"
  }

  set {
    name  = "controller.env[12].value"
    value = "true"
  }

  set {
    name  = "controller.env[13].name"
    value = "ARM_USE_MANAGED_IDENTITY_EXTENSION"
  }

  set {
    name  = "controller.env[13].value"
    value = "false"
  }

  set {
    name  = "controller.env[14].name"
    value = "ARM_USER_ASSIGNED_IDENTITY_ID"
  }

  set {
    name  = "controller.env[14].value"
    value = ""
  }

  set {
    name  = "controller.env[15].name"
    value = "AZURE_NODE_RESOURCE_GROUP"
  }

  set {
    name  = "controller.env[15].value"
    value = "MC_karpenter_karpenter_eastus"
  }

  set {
    name  = "serviceAccount.name"
    value = "karpenter-sa"
  }

  set {
    name  = "serviceAccount.annotations.azure.workload.identity/client-id"
    value = "<>"
  }

  set {
    name  = "podLabels.azure.workload.identity/use"
    value = "true"
  }


  wait = true
}
