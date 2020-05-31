terraform {
    backend "azurerm" {
        resource_group_name             = "remote-state"
        storage_account_name            = "udemyterraform1054"
        container_name                  = "tfstate"
        key                             = "bastion.tstate"
    }
}