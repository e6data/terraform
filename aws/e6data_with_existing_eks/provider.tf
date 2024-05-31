# Comment out this block if storing Terraform state is required.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

# Uncomment this block if storing Terraform state is required & update the bucket name.

# terraform {
#  backend "s3" {
#    bucket = "<bucket_name_to_store_the_tfstate_file>"
#    key    = "terraform/state.tfstate"
#    region = var.aws_region
#  }
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "4.22.0"
#    }
#  }
# }

provider "aws" {
  region = var.aws_region
#  access_key = "YOUR_AWS_ACCESS_KEY"
#  secret_key = "YOUR_AWS_SECRET_KEY"
  default_tags {
    tags = {
      app  = "e6data"
    }
  }
}