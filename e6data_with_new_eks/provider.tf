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
  backend "s3" {
    bucket = "internal-terraform-state"
    key    = "finale-harshith/finale.tfstate"
    region = "us-east-1"
  }
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.35.0"
    }

    kubectl = {
      source = "alekc/kubectl"
      version = "2.0.4"
    }
  } 
}