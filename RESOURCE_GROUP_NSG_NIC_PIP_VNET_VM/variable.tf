variable "web_server_location" {
   type = "string"
}
variable "web_server_rg" {
   type = "string"
}
variable "resource_prefix" {
   type = "string"
}
variable "web_server_address_space" {
   type = "string" 
# it did not work unless I declared the type
}
variable "web_server_address_prefix" {
   type = "string"
}
variable "web_server_name" {
   type = "string"
}
variable "environment" {
   type = "string"
}

