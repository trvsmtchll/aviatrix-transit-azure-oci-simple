variable "username" {
  type    = string
  default = ""
}

variable "password" {
  type    = string
  default = ""
}

variable "controller_ip" {
  type    = string
  default = ""
}

### Azure

variable "azure_vm_spokes" {
  description = "Map of Names and CIDR ranges to be used for the Spoke VNETSs"
  type        = map(string)
}

variable "azure_account_name" {
  default = ""
}

variable "azure_transit_cidr1" {
  default = ""
}

variable "azure_aks_spoke_cidr" {
  default = ""
}

variable "azure_region1" {
  default = ""
}

variable "azure_gw_size" {
  default = ""
}

variable "azure_spoke1_name" {
  type    = string
  default = ""
}

variable "azure_spoke1_cidr" {
  type    = string
  default = ""
}

variable "azure_spoke1_region" {
  type    = string
  default = ""
}

variable "azure_spoke2_name" {
  type    = string
  default = ""
}

variable "azure_spoke2_cidr" {
  type    = string
  default = ""
}

variable "azure_spoke2_region" {
  type    = string
  default = ""
}

variable "insane" {
  type    = bool
  default = true
}

variable "ha_enabled" {
  type    = bool
  default = true
}

variable "azure_test_vm_rg" {
  type    = string
  default = ""
}

variable "instance_size" {
  type    = string
  default = ""
}

variable "test_instance_size" {
  type    = string
  default = ""
}

##################

# Variables required by the OCI Provider
variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "region" {
}

variable "private_key_path" {
}

variable "compartment_ocid" {
  type    = string
  default = ""
}

variable "oci_transit_cidr" {
  default = ""
}

variable "oci_transit_region" {
  default = ""
}

variable "oci_account_name" {
  description = "The name of your OCI Access Account defined in Aviatrix Controller"
  default     = ""
}

variable "ssh_public_key" {
  default = ""
}

variable "oci_app_spokes" {
  description = "Name, cidr, region"
  type = map(object({
    name   = string
    cidr   = string
    region = string
  }))
}

variable "oci_db_spokes" {
  description = "Name, cidr, region, db parameters"
  type = map(object({
    name   = string
    cidr   = string
    region = string
    cpu_core_count      = number
    size_in_tbs         = number
    db_name             = string
    db_workload         = string
    enable_auto_scaling = bool
  }))
}

variable "nsg_whitelist_ip" {
  type    = string
  default = ""
}
