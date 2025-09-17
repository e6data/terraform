terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.35.0"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.4"
    }
    
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id   = var.subscription_id
}