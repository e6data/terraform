module "karpenter" {
  source                  = "./modules/karpenter"
  provider                 = helm.e6data
  
  depends_on = [module.network]
}