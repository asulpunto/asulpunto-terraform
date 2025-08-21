
resource "azurerm_virtual_network" "example"
{
    name = "example-subnet"
    resource_group_name = azurerm_resource_group.example.name
    location =var.location
    address_space = ['172.16.0.0/16']
}