terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    access_key           = "ZHGaR/dNcP/Y9AbUgTWPNx8HwqAWcjoXjfDt5qGQXjqfKeTH8wuKdjxncElQrd2Beus4uqO0Df7i+AStbLjnPQ=="
    key                  = "terraform.tfstate"
  }
}