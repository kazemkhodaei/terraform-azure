terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    access_key           = "HiNl25eGPmhw1KesRst6NIwg4p/D2OnIDOhp6Qsce/H1zqJZTTtlmD/PEmEBrDzrgDeITUenWh4N+AStUxwXaw=="
    key                  = "terraform.tfstate"
  }
}