resource "azurerm_key_vault" "weathe-keyvault" {
  name                = "weather-kv"
  location            = azurerm_resource_group.terraformResource.location
  resource_group_name = var.resource_group_name
  tenant_id           = azurerm_app_service.weater_app_service.id
  sku_name            = "standard"

}


