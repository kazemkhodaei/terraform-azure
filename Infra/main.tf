provider "azurerm" {
  features {

  }

    client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}


variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

terraform {
  required_providers {
    azurerm={
      source = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
  required_version = "~> 1.6.6"
}

## mark version that you are working 
## if somebody download wrong version it will break 
## try to use  >version 
## add features https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block