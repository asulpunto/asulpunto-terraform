resource "azurerm_resource_group_group" "example" {
    name = "example-resources"
    location = var.location
}