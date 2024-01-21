terraform {
  backend "azurerm" {
    resource_group_name = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name = "tfstate"
    access_key = "/0he+A4Z+5dGZ1/4YxasFq6mLBk8OfBCazi9drR65l0B5aOcgO+Br3CpTJXAXpLkL40D+IyL6NiI+AStqFBxpw=="
    key = "terraform.tfstate"
  }
}