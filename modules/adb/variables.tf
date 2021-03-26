/*variable "adw_params" {
  type = map(object({
    cpu_core_count      = number
    size_in_tbs         = number
    db_name             = string
    db_workload         = string
    enable_auto_scaling = bool
  }))
}*/

variable "cpu_core_count" {
  type = number
}

variable "size_in_tbs" {
  type = number
}

variable "db_name" {
  type = string
  default = ""
}

variable "db_workload" {
  type = string
  default = ""
}

variable "enable_auto_scaling" {
  type = bool
  default = true
}

variable "compartment_ocid" {
  type = string
  default = ""
}

variable "adb_nsg_ids" {
  default = ""
}

variable "adb_subnet_id" {
  default = ""
}