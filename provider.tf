provider "aviatrix" {
  controller_ip           = var.controller_ip
  username                = var.username
  password                = var.password
  skip_version_validation = true
  version                 = "2.18.1"
}

provider "azurerm" {
  version = "=2.30.0"
  features {}
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
  version          = "~> 4.2.0"
}
