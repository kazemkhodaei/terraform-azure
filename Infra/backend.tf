terraform {
  backend "azurerm" {
    resource_group_name = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name = "tfstate"
    access_key = "aKe8UEChcKf0RDHQAGCRqjpR+kFhAGAjrsbCYRZWPOms6YDhxK3ZWAbOrcE98yqfjnZBXr9QBvhL+AStp/5UNA=="
    key = "terraform.tfstate"
  }
}