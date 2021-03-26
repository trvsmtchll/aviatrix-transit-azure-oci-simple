/*terraform {
  required_providers {
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.47.0"
    }
  required_version = "0.13"
}
*/

terraform {
  required_providers {
    aviatrix = {
      source = "aviatrixsystems/aviatrix"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      #version = "2.47.0"
    }
  }
  required_version = ">= 0.13"
}
