provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "terraformResource" {
  name     = var.resource_group_name
  location = "west europe"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "kzmainstorageaccount"
  resource_group_name      = var.resource_group_name
  location                 = azurerm_resource_group.terraformResource.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}


resource "azurerm_app_service_plan" "weather" {
  name                = "weather-appserviceplan"
  location            = azurerm_resource_group.terraformResource.location
  resource_group_name = azurerm_resource_group.terraformResource.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "weater_app_service" {
  name                = "kz-weather-app-service"
  location            = azurerm_resource_group.terraformResource.location
  resource_group_name = azurerm_resource_group.terraformResource.name
  app_service_plan_id = azurerm_app_service_plan.weather.id

    app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}


output "storage_account_connection_string" {
  value = azurerm_storage_account.storage_account.primary_connection_string
  sensitive = true
}
