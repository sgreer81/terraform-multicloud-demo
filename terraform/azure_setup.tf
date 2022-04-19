# Basic Azure setup including resource group, virutal network and subnet

resource "azurerm_resource_group" "demo1" {
  name     = "demo1"
  location = "West Europe"
}

resource "azurerm_virtual_network" "demo1" {
  name                = "demo1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo1.location
  resource_group_name = azurerm_resource_group.demo1.name
}

resource "azurerm_subnet" "demo1" {
  name                 = "demo1"
  resource_group_name  = azurerm_resource_group.demo1.name
  virtual_network_name = azurerm_virtual_network.demo1.name
  address_prefixes     = ["10.0.2.0/24"]
}
