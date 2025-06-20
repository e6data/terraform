data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

module "compute_plane_endpoint_services" {
  source = "./modules/endpoint_services"

  providers = {
    kubernetes = kubernetes.e6data
    helm       = helm.e6data
  }

  eks_cluster_name = module.eks.cluster_name
  allowed_principals = var.allowed_principals
  nginx_image_repository = var.nginx_image_repository
  nginx_image_tag = var.nginx_image_tag
  nameOverride = var.nameOverride
}

module "compute_plane_vpc_endpoints" {
  source = "./modules/interface_vpc_endpoints"

  for_each = var.interface_vpc_endpoints

  vpc_id            = module.network.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = each.value.vpc_endpoint_type
  subnet_ids        = module.network.private_subnet_ids
  ingress_rules     = each.value.ingress_rules
  egress_rules      = each.value.egress_rules
  name              = each.key
  workspace_name    = var.workspace_name
}