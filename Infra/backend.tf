terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "kzterraformstate"
    container_name       = "tfstate"
    access_key           = "446H6ireMNxci8swR12uSFXnL98DgS6/iYPL0e1aJvZ9VcNtziWNpuNksTkblOmeypiMy/rwJNIh+AStNRghAw=="
    key                  = "terraform.tfstate"
  }
}