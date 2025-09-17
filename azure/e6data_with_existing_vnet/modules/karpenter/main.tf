terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

resource "helm_release" "karpenter" {
  name             = "karpenter"
  chart            = "karpenter"
  repository       = "oci://mcr.microsoft.com/aks/karpenter"
  version          = var.karpenter_version
  namespace        = var.karpenter_namespace
  create_namespace = true

  values = [
    yamlencode({
      controller = {
        env = [
          {
            name  = "FEATURE_GATES"
            value = "Drift=true"
          },
          {
            name  = "LEADER_ELECT"
            value = "true"
          },
          {
            name  = "CLUSTER_NAME"
            value = var.aks_cluster_name
          },
          {
            name  = "CLUSTER_ENDPOINT"
            value = "${var.aks_cluster_endpoint}"
          },
          {
            name  = "KUBELET_BOOTSTRAP_TOKEN"
            value = var.bootstrap_token
          },
          {
            name  = "NETWORK_PLUGIN"
            value = "azure"
          },
          {
            name  = "NETWORK_POLICY"
            value = ""
          },
          {
            name  = "NODE_IDENTITIES"
            value = var.node_identities
          },
          {
            name  = "ARM_SUBSCRIPTION_ID"
            value = var.subscription_id
          },
          {
            name  = "LOCATION"
            value = var.location
          },
          {
            name  = "VNET_SUBNET_ID"
            value = var.aks_subnet_id
          },
          {
            name  = "SSH_PUBLIC_KEY"
            value = var.public_ssh_key
          },
          {
            name  = "ARM_USE_CREDENTIAL_FROM_ENVIRONMENT"
            value = "true"
          },
          {
            name  = "ARM_USE_MANAGED_IDENTITY_EXTENSION"
            value = "false"
          },
          {
            name  = "ARM_USER_ASSIGNED_IDENTITY_ID"
            value = ""
          },
          {
            name  = "VNET_GUID"
            value = var.vnet_guid
          },
          {
            name  = "AZURE_NODE_RESOURCE_GROUP"
            value = var.node_resource_group
          }
        ]
      },
      serviceAccount = {
        name = var.karpenter_service_account_name
        annotations = {
          "azure.workload.identity/client-id" = var.karpenter_managed_identity_client_id
        }
      },
      podLabels = {
        "azure.workload.identity/use" = "true"
      }
    })
  ]

  wait = true
}
