terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

## use msi (manage service Identity) to instead of user access_key 
## use azure ad authentication 
## https://developer.hashicorp.com/terraform/language/settings/backends/azurerm 
## reasearch to find the best approach 
## test environment which can accessible and prod is not accessible