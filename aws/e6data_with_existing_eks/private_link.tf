data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

module "compute_plane_endpoint_services" {
  source = "./modules/endpoint_services"

  providers = {
    kubernetes = kubernetes.eks_e6data
    helm       = helm.eks_e6data
  }

  eks_cluster_name = var.eks_cluster_name
  allowed_principals = var.allowed_principals
  nginx_image_repository = var.nginx_image_repository
  nginx_image_tag = var.nginx_image_tag
  tolerations = var.tolerations
  nameOverride = var.nameOverride
}

module "compute_plane_vpc_endpoints" {
  source = "./modules/endpoints"

  for_each = var.vpc_endpoints

  vpc_id            = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = each.value.vpc_endpoint_type
  subnet_ids        = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  ingress_rules     = each.value.ingress_rules
  egress_rules      = each.value.egress_rules
  name              = each.key
}