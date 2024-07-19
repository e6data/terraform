terraform {
  # backend "azurerm" {
  #   resource_group_name  = "e6data-common"
  #   storage_account_name = "e6dataengine"
  #   container_name       = "terraform"
  #   key                  = "<>.terraform.tfstate"
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
