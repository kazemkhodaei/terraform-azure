provider "azurerm" {
  features {

  }
}

terraform {
  required_providers {
     mssql = {
      source = "betr-io/mssql"
      version = "0.3.1"
    }
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