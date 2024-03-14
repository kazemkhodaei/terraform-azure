provider "azurerm" {
  features {

  }
}

terraform {
  required_providers {
     mssql = {
      source = "betr-io/mssql"
      version = "0.2.7"
    }
    azurerm={
      source = "hashicorp/azurerm"
      version = "3.85.0"
    }
  }
  required_version = "~> 1.6.6"
}

provider "mssql" {
  # Configuration options
}
