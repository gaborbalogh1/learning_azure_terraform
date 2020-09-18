# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  version = "=2.20.0"
  features {}
}

resource "azurerm_resource_group" "TerraformAzure" {
  name     = "${var.prefix}-Test"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.TerraformAzure.location
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.TerraformAzure.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.TerraformAzure.name
  address_prefix       = var.subnet_prefix
}

resource "azurerm_network_security_group" "TF-sg" {
  name                = "${var.prefix}-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.TerraformAzure.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "TF-nic" {
  name                      = "${var.prefix}-TF-nic"
  location                  = var.location
  resource_group_name       = azurerm_resource_group.TerraformAzure.name
  # network_security_group_id = azurerm_network_security_group.TF-sg.id

  ip_configuration {
    name                          = "${var.prefix}ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.TF-pip.id
  }
}

resource "azurerm_public_ip" "TF-pip" {
  name                = "${var.prefix}-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.TerraformAzure.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.prefix}-TFC"
}

resource "azurerm_virtual_machine" "TF" {
  name                = "${var.prefix}-TFC"
  location            = var.location
  resource_group_name = azurerm_resource_group.TerraformAzure.name
  vm_size             = var.vm_size

  network_interface_ids         = [azurerm_network_interface.TF-nic.id]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = var.prefix
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
