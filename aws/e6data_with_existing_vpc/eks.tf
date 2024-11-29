module "eks" {
  source                           = "./modules/eks"
  cluster_name                     = var.cluster_name
  kube_version                     = var.kube_version
  cluster_log_types                = var.cluster_log_types
  cloudwatch_log_retention_in_days = var.cloudwatch_log_retention_in_days
  security_group_ids               = [module.security_group.security_group_id]
  subnet_ids                       = module.network.subnet_ids
  private_subnet_ids               = module.network.private_subnet_ids
  public_access_cidrs              = var.public_access_cidrs
  endpoint_private_access          = var.endpoint_private_access
  vpc_id                           = module.network.vpc_id

  depends_on = [module.network]
}

resource "aws_ec2_tag" "cluster_primary_security_group" {
  resource_id = module.eks.cluster_primary_security_group_id
  key         = "app"
  value       = "e6data"
}

provider "kubernetes" {
  alias                  = "e6data"
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_certificate_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = var.aws_command_line_path
  }
}

provider "kubectl" {
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.eks_certificate_data)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = var.aws_command_line_path
  }
}

provider "helm" {
  alias = "e6data"
  kubernetes {
    host                   = module.eks.eks_endpoint
    cluster_ca_certificate = base64decode(module.eks.eks_certificate_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = var.aws_command_line_path
    }
  }
}

resource "kubectl_manifest" "eni_config" {
  
  for_each = length(var.additional_cidr_block) > 0 ? {
    for index, subnet_id in module.network.additional_private_subnet_ids : index => {
      az_name   = data.aws_availability_zones.available.names[index]
      subnet_id = subnet_id
    }
  } : {}

  yaml_body = <<EOF
apiVersion: crd.k8s.amazonaws.com/v1alpha1
kind: ENIConfig
metadata:
  name: "${each.value.az_name}"
spec:
  subnet: "${each.value.subnet_id}"
EOF
}


resource "kubectl_manifest" "aws_node_patch" {
  count = length(var.additional_cidr_block) > 0 ? 1 : 0
  yaml_body = <<EOT
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: aws-node
  namespace: kube-system
spec:
  template:
    spec:
      containers:
        - name: aws-node
          env:
            - name: AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG
              value: "true"
            - name: ENI_CONFIG_LABEL_DEF
              value: "failure-domain.beta.kubernetes.io/zone"
EOT

  wait = false
}