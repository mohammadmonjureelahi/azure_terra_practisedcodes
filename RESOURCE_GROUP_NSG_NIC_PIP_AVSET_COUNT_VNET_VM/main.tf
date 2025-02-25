# Create a resource group
resource "azurerm_resource_group" "web_server_rg" {
  name                              = "${var.web_server_rg}"
  location                          = "${var.web_server_location}"

}

resource "azurerm_virtual_network" "web_server_vnet" {
  name                              = "${var.resource_prefix}-vnet"
  location                          = "${var.web_server_location}"
  resource_group_name               = "${azurerm_resource_group.web_server_rg.name}"
  address_space                     = [var.web_server_address_space]
}

resource "azurerm_subnet" "web_server_subnet" {
  name                              = "${var.resource_prefix}-subnet"
  resource_group_name               = "${azurerm_resource_group.web_server_rg.name}"
  virtual_network_name              = "${azurerm_virtual_network.web_server_vnet.name}"
  address_prefix                    = "${var.web_server_address_prefix}"
}  

resource "azurerm_network_interface" "web_server_nic" {
  name                              = "${var.web_server_name}-${format("%02d",count.index)}-nic"
  location                          = "${var.web_server_location}"
  resource_group_name               = "${azurerm_resource_group.web_server_rg.name}"
  count                             = "${var.web_server_count}"  

  ip_configuration {
  name                              = "${var.web_server_name}-ip"
  subnet_id                         = "${azurerm_subnet.web_server_subnet.id}"
  private_ip_address_allocation     = "dynamic"  
  public_ip_address_id              = count.index == 0 ? "${azurerm_public_ip.web_server_public_ip.id}" : null # added later when we configured the VM

  }
}

resource "azurerm_public_ip" "web_server_public_ip" {
  name                              = "${var.resource_prefix}-public-ip"
  location                          = "${var.web_server_location}"
  resource_group_name               = "${azurerm_resource_group.web_server_rg.name}"
  allocation_method                 = "${var.environment}" == "production" ? "Static" : "Dynamic"
}

resource "azurerm_network_security_group" "web_server_nsg" {
  name                              = "${var.resource_prefix}-nsg"
  location                          = "${var.web_server_location}"
  resource_group_name               = "${azurerm_resource_group.web_server_rg.name}"
}
resource "azurerm_network_security_rule" "web_server_nsg_rule_rdp" {
  name                              = "RDP Inbound"
  priority                          = 100
  direction                         = "Inbound"
  access                            = "Allow"
  protocol                          = "Tcp"
  source_port_range                 = "*"
  destination_port_range            = "3389"
  source_address_prefix             = "*"
  destination_address_prefix        = "*"  
  resource_group_name               = "${azurerm_resource_group.web_server_rg.name}"
  network_security_group_name       = "${azurerm_network_security_group.web_server_nsg.name}"  
}

resource "azurerm_subnet_network_security_group_association" "web_server_sag" {
  network_security_group_id         = "${azurerm_network_security_group.web_server_nsg.id}"
  subnet_id                         = "${azurerm_subnet.web_server_subnet.id}"
}

resource "azurerm_windows_virtual_machine" "web-server" {
  name                              = "${var.web_server_name}-${format("%02d",count.index)}"
  location                          = "${var.web_server_location}"
  resource_group_name               = "${azurerm_resource_group.web_server_rg.name}"
  network_interface_ids             = ["${azurerm_network_interface.web_server_nic[count.index].id}"]
  count                             = "${var.web_server_count}"
  availability_set_id               = "${azurerm_availability_set.web_server_availability_set.id}"
  size                              = "standard_B1s"
  admin_username                    = "webserveruser"
  admin_password                    = "Secret555"
  

  os_disk {
    caching                         = "ReadWrite"
    storage_account_type            = "Standard_LRS"
  }

  source_image_reference {
    publisher                       = "MicrosoftWindowsServer"
    offer                           = "WindowsServerSemiAnnual"
    sku                             = "Datacenter-Core-1709-smalldisk"
    version                         = "latest"
  }
}

resource "azurerm_availability_set" "web_server_availability_set" {
  name                              = "${var.resource_prefix}-availability-set"
  location                          = "${var.web_server_location}"
  resource_group_name               = "${azurerm_resource_group.web_server_rg.name}"
  managed                           = true 
  platform_fault_domain_count       = 2
  
}






