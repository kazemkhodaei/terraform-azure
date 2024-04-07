terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    access_key           = "nV/9JpYC2JSpnCe3ZxiiF/GU8RwJGHZzJ6eRQzJtxA7gzuuWwlxp4tL4GaMzJ0Y8DWvVMsNmQh3m+AStOQv7aw=="
    key                  = "terraform.tfstate"
  }
}

## use msi (manage service Identity) to instead of user access_key 
## use azure ad authentication 
## https://developer.hashicorp.com/terraform/language/settings/backends/azurerm 
## reasearch to find the best approach 
## test environment which can accessible and prod is not accessible