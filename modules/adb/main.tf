resource "random_string" "autonomous_database_wallet_password" {
  length           = 16
  special          = true
  min_upper        = 3
  min_lower        = 3
  min_numeric      = 3
  min_special      = 3
  override_special = "{}#^*<>[]%~"
}

data "oci_database_autonomous_database_wallet" "autonomous_database_wallet" {
  autonomous_database_id = oci_database_autonomous_database.adb.id
  password               = random_string.autonomous_database_wallet_password.result
  base64_encode_content  = "true"
}

resource "oci_database_autonomous_database" "adb" {
  admin_password           = random_string.autonomous_database_wallet_password.result
  compartment_id           = var.compartment_ocid
  nsg_ids                  = var.adb_nsg_ids
  subnet_id                = var.adb_subnet_id
  cpu_core_count           = var.cpu_core_count
  data_storage_size_in_tbs = var.size_in_tbs
  db_name                  = var.db_name
  display_name             = var.db_name
  db_workload              = var.db_workload
  is_auto_scaling_enabled  = var.enable_auto_scaling
  license_model            = "BRING_YOUR_OWN_LICENSE"
  is_free_tier             = false
}

resource "local_file" "autonomous_database_wallet_file" {
  content_base64 = data.oci_database_autonomous_database_wallet.autonomous_database_wallet.content
  filename       = "${path.module}/../../${var.db_name}_database_wallet.zip"
  #filename       = "../../${var.db_name}_database_wallet.zip"
}