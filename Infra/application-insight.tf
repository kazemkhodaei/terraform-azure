resource "azurerm_application_insights" "kazem_application_insight" {
  application_type    = "web"
  resource_group_name = var.resource_group_name
  name                = "kazem-application-insight"
  location            = azurerm_resource_group.terraformResource.location
}