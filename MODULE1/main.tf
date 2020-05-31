provider "azurerm" {
  version = "2.2.0"
  features {}
}

provider "random" {
  version = "2.2"
}

module "location_useast" {
  source = "./location"

web_server_location             = "eastus"
web_server_rg                   = "${var.web_server_rg}-useast"
resource_prefix                 = "${var.resource_prefix}-useast"
web_server_address_space        = "10.0.0.0/16"
web_server_name                 = "${var.web_server_name}"    
environment                     = "${var.environment}"        
web_server_count                = "${var.web_server_count}"

web_server_subnets              = {
  web-server                    = "10.0.0.0/24"
  AzureBastionSubnet            = "10.0.1.0/24"
}

terraform_script_version        = "${var.terraform_script_version}"
admin_password                  = "${data.azurerm_key_vault_secret.admin_password.value}"  
 
}

module "location_useast2" {
  source = "./location"

web_server_location             = "eastus2"
web_server_rg                   = "${var.web_server_rg}-useast2"
resource_prefix                 = "${var.resource_prefix}-useast2"
web_server_address_space        = "192.168.0.0/16"
web_server_name                 = "${var.web_server_name}"    
environment                     = "${var.environment}"        
web_server_count                = "${var.web_server_count}"

web_server_subnets              = {
  web-server                    = "192.168.0.0/24"
  AzureBastionSubnet            = "192.168.1.0/24"
}

terraform_script_version        = "${var.terraform_script_version}"
admin_password                  = "${data.azurerm_key_vault_secret.admin_password.value}"  
 
}