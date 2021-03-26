output "transit_vnet" {
  value = module.azure_transit_1.azure_vnet_name
}

output "transit_gateway" {
  value = module.azure_transit_1.transit_gateway.gw_name
}

output "spoke" {
  value = module.azure_spoke
}

output "aks" {
  value = azurerm_kubernetes_cluster.aks
}

output "nginx" {
  value = helm_release.nginx
}

output "test_vm" {
  value = module.azure_test_vm
}

output "test_vm_password" {
  value = random_password.password.result
}

output "autonomous_db" {
  value = module.autonomous_db
}

output "flex_vm" {
  value = module.flex_vm
}

output "oci_app_spoke" {
  value = module.oci_app_spoke
}

output "oci_db_spoke" {
  value = module.oci_db_spoke
}