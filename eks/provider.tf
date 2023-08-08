# Configure the AWS Provider
provider "aws" {
  region  = var.aws_region

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
    google = {
      source = "hashicorp/google"
      version = "4.46.0"
    }
  } 
}