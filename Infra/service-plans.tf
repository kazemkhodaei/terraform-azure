resource "azurerm_service_plan" "weather" {
  name                = "weather-appserviceplan"
  location            = azurerm_resource_group.terraformResource.location
  resource_group_name = azurerm_resource_group.terraformResource.name
  sku_name            = "B1"
  os_type             = "Windows"
}
