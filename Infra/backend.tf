terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    access_key           = "MonhtBD92IulV4dnPORoR9/wlWK+q8TnmQl9vW96CYaADXCzL8D2UPynykX/Gvmtgco7tQrLp8v6+ASt2KAPxg=="
    key                  = "terraform.tfstate"
  }
}