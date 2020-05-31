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
domain_name_label               = "${var.domain_name_label}"  
 
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
domain_name_label               = "${var.domain_name_label}"  
 
}

resource "azurerm_resource_group" "global-rg" {
  name                          = "traffic-manager-rg"
  location                      = "eastus"  
}

resource "azurerm_traffic_manager_profile" "traffic_manager" {
  name                          = "${var.resource_prefix}-traffic-manager"
  resource_group_name           = "${azurerm_resource_group.global-rg.name}"
  traffic_routing_method        = "Weighted"

  dns_config {
    relative_name               = "${var.domain_name_label}"  
    ttl                         = 100
  }

  monitor_config {
    protocol                    = "http"
    port                        = 80
    path                        = "/"

  }
}

resource "azurerm_traffic_manager_endpoint" "traffic_manager_useast" {
  name                          = "${var.resource_prefix}-useast-endpoint"
  resource_group_name           = "${azurerm_resource_group.global-rg.name}"
  profile_name                  = "${azurerm_traffic_manager_profile.traffic_manager.name}"  
  target_resource_id            = "${module.location_useast.web_server_lb_public_ip_id}"
  type                          = "azureEndpoints"
  weight                        = 100
}

resource "azurerm_traffic_manager_endpoint" "traffic_manager_useast2" {
  name                          = "${var.resource_prefix}-useast2-endpoint"
  resource_group_name           = "${azurerm_resource_group.global-rg.name}"
  profile_name                  = "${azurerm_traffic_manager_profile.traffic_manager.name}"  
  target_resource_id            = "${module.location_useast2.web_server_lb_public_ip_id}"
  type                          = "azureEndpoints"
  weight                        = 100
}


