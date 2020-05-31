web_server_location             = "eastus"
web_server_rg                   = "web-rg"
resource_prefix                 = "web-server"
web_server_address_space        = "10.0.0.0/16"
web_server_address_prefix       = "10.0.0.0/24"
web_server_name                 = "web"    
environment                     = "development"        
web_server_count                = 2    
web_server_subnets              = {
    web-server                  = "10.0.0.0/24"
    AzureBastionSubnet          = "10.0.1.0/24"
}
terraform_script_version        = "1.0.0"    