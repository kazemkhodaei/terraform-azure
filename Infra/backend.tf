terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    access_key           = "y2AbVdQDkOLWcbSLWmr/yQV/o6q2jeTse+sYPPj5FOnraNCgdgGuOYtFVMO91EIAPYNGqIOEn5D2+ASt+R0KRA=="
    key                  = "terraform.tfstate"
  }
}