terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    access_key           = "YbYaB8A2rLa6aSdkkZRprGwtfO1ZOwhvrRUd56kkHxsUa4PJeS6exLLU8dBB8+g/MphHaZCfS5xZ+AStpffvLw=="
    key                  = "terraform.tfstate"
  }
}