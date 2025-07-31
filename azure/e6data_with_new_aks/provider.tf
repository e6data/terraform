terraform {
    backend "azurerm" {
      resource_group_name  = "analytics"
      storage_account_name = "wstfstate123"
      container_name       = "complete-private"
      key                  = "terraform.tfstate"
    }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
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
