terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    access_key           = "u9wAHFaXTCImz7EskShDae6LWV5ExvOCcHw+W4zAyKAkzRxQ4A5QmxNgl6KiEx5Ev7VIAg4SBmTU+AStGx1IbA=="
    key                  = "terraform.tfstate"
  }
}