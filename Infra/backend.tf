terraform {
  backend "azurerm" {
    resource_group_name = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name = "tfstate"
    access_key = "fYqlYrY4v8jBXso60j0MuNbQslmabGuABUVw8Eh1a1hDyfpxt9ex6CowRjmbw6izuV0UI38jzfTx+AStwNXCcw=="
    key = "terraform.tfstate"
  }
}