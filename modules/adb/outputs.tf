/*output "ad" {
  value = {
    for idx, ad in oci_database_autonomous_database.adb:
      ad.db_name => { "connection_strings" : ad.connection_strings.0.all_connection_strings, "password" : random_string.autonomous_database_wallet_password[idx].result }
  }
}*/

output "adb_password" {
  value = random_string.autonomous_database_wallet_password.result
}

output "adb_connection_strings" {
  value = oci_database_autonomous_database.adb.connection_strings.0.all_connection_strings
}

output "apex_url" {
  value = oci_database_autonomous_database.adb.connection_urls.0.apex_url
}

output "db_infrastructure" {
  value = oci_database_autonomous_database.adb.infrastructure_type
}

output "private_endpoint" {
  value = oci_database_autonomous_database.adb.private_endpoint
}

output "private_endpoint_ip" {
  value = oci_database_autonomous_database.adb.private_endpoint_ip
}