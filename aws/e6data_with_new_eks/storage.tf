resource "aws_eks_addon" "ebs_storage_driver" {
  cluster_name = module.eks.cluster_name
  addon_name   = "aws-ebs-csi-driver"
  service_account_role_arn = module.ebs_driver_oidc.oidc_role_arn

  depends_on = [ module.ebs_driver_oidc ]


}
resource "kubernetes_storage_class" "storage_class" {
  provider = kubernetes.e6data

  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" : "true"
    }
  }

  parameters = {
    type = "gp3"
  }

  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"

  allow_volume_expansion = true 

  depends_on = [ aws_eks_addon.ebs_storage_driver ]
}

module "ebs_driver_oidc" {
  source = "./modules/aws_oidc"

  providers = {
    kubernetes = kubernetes.e6data
  }

  tls_url      = module.eks.eks_oidc_tls
  policy_arn   = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
  eks_oidc_arn = module.eks.oidc_arn

  oidc_role_name = "${module.eks.cluster_name}-ebs-driver-oidc-role"

  kubernetes_namespace            = "kube-system"
  kubernetes_service_account_name = "ebs-csi-controller-sa"

  
}
