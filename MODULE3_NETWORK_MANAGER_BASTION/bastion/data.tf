data "terraform_remote_state" "web" {
  backend = "azurerm" 
  config = {
        resource_group_name             = "remote-state"
        storage_account_name            = "udemyterraform1054"
        container_name                  = "tfstate"
        key                             = "web.tstate"
    }
}



    
