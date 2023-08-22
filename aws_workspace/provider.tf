# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  # access_key = "<Access key ID>"
  # secret_key = "<Secret access key>"
  default_tags {
    tags = var.cost_tags
  }
}

terraform {
  /* backend "s3" {} */
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22.0"
    }
  } 
}