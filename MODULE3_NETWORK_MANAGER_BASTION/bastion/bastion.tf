provider "azurerm" {
  version = "2.2.0"
  features {}
}

resource "azurerm_resource_group" "bastion-rg" {
  name                          = "${var.bastion_rg}"
  location                      = "${var.location}"  
}

resource "azurerm_public_ip" "bastion_pip" {
  name                              = "bastion-ip"
  location                          = "${var.location}"
  resource_group_name               = "${azurerm_resource_group.bastion-rg.name}"
  allocation_method                 = "Static"
  sku                               = "Standard"    
}

resource "azurerm_bastion_host" "bastion_host" {
  name                              = "bastion-host"
  location                          = "${var.location}"
  resource_group_name               = "${azurerm_resource_group.bastion-rg.name}"

  ip_configuration {
      name                          = "useast"
      subnet_id                     = "${data.terraform_remote_state.web.outputs.bastion_host_subnet_useast}"
      public_ip_address_id          = "${azurerm_public_ip.bastion_pip.id}"
  }
}
