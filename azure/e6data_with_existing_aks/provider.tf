terraform {
  # backend "azurerm" {
  #   resource_group_name  = "backend-rg"
  #   storage_account_name = "backend-storage-account"
  #   container_name       = "backend-container"
  #   key                  = "terraform.tfstate"
  # }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.110.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.4"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id   = var.subscription_id
}
