terraform {
  backend "azurerm" {
    resource_group_name  = "e6data-common"
    storage_account_name = "e6dataengine"
    container_name       = "terraform"
    key                  = "engine.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.71.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

provider "azurerm" {
  features {}
}
