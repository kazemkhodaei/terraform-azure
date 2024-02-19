terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    access_key           = "LnUz31PCfpxOYw2gTnW1M44i6utXi6TxVskomht6mRVQWudSsMAXBSNmfvZiSeSSBVWS3Z9qzw/v+AStgQHIww=="
    key                  = "terraform.tfstate"
  }
}