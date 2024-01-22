terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    access_key           = "JPjCXjDOMZB1AjkYcaC/VqsaSouBrpPB9RxXaqQfjQrBIgM6vhY8LvSuDFhWWXgG4NAytGwLxyqA+AStzElaXg=="
    key                  = "terraform.tfstate"
  }
}