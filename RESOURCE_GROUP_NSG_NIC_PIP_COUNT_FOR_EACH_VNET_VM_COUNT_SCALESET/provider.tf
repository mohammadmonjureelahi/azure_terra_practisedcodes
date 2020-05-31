provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  //version = "${var.azure_provider_version}"
  version = "2.2.0"
  features {}
}
