# Create S3 bucket for workspace
module "e6data_s3_bucket" {
  source = "./modules/s3"
  bucket_name = "${local.e6data_workspace_name}-${random_string.random.result}"
  cost_tags = var.cost_tags
}