resource "azurerm_resource_group" "example" {
    name = "example-resources"
    location = var.location
}

module "vnet" {
    source = "../../modules/vnet"   
    location = var.location
    resource_group_name = azurerm_resource_group.example.name

} 