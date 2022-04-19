# Creates an Azure linux VM with public IP address using the azure_vm_init.sh to setup server
resource "azurerm_linux_virtual_machine" "app_server_2" {
  name                = "AppServer2"
  resource_group_name = azurerm_resource_group.demo1.name
  location            = azurerm_resource_group.demo1.location
  network_interface_ids = [
    azurerm_network_interface.demo1.id,
  ]
  size = "Standard_D2ads_v5"

  admin_username                  = "adminuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  custom_data = filebase64("${path.module}/scripts/azure_vm_init.sh")
}

# Creates a public IP for the VM
resource "azurerm_public_ip" "demo1" {
  name                = "demo1"
  location            = azurerm_resource_group.demo1.location
  resource_group_name = azurerm_resource_group.demo1.name
  allocation_method   = "Dynamic"
}

# Creates Network Security Group and rule allowing inbound traffic on port 22 and 80
resource "azurerm_network_security_group" "demo1" {
  name                = "demo1"
  location            = azurerm_resource_group.demo1.location
  resource_group_name = azurerm_resource_group.demo1.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Creates a network interface to be attached to the VM
resource "azurerm_network_interface" "demo1" {
  name                = "demo1"
  location            = azurerm_resource_group.demo1.location
  resource_group_name = azurerm_resource_group.demo1.name

  ip_configuration {
    name                          = "demo1"
    subnet_id                     = azurerm_subnet.demo1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo1.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "demo1" {
  network_interface_id      = azurerm_network_interface.demo1.id
  network_security_group_id = azurerm_network_security_group.demo1.id
}
