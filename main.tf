# Azure Transit Module
module "azure_transit_1" {
  #source                 = "./terraform-aviatrix-azure-transit"
  source                 = "terraform-aviatrix-modules/azure-transit/aviatrix"
  version                = "3.0.0"
  name                   = "test-transit"
  instance_size          = var.instance_size
  ha_gw                  = var.ha_enabled
  cidr                   = var.azure_transit_cidr1
  region                 = var.azure_region1
  account                = var.azure_account_name
  enable_transit_firenet = true
}

resource "azurerm_resource_group" "example" {
  name     = "aviatrix-poc-rg"
  location = var.azure_region1
}

# Azure VM Spokes
module "azure_spoke" {
  for_each      = var.azure_vm_spokes
  source        = "terraform-aviatrix-modules/azure-spoke/aviatrix"
  version       = "3.0.0"
  name          = each.key
  cidr          = each.value
  region        = var.azure_region1
  account       = var.azure_account_name
  ha_gw         = var.ha_enabled
  instance_size = var.instance_size
  transit_gw    = module.azure_transit_1.transit_gateway.gw_name
}

# Azure Test VMs
module "azure_test_vm" {
  for_each                      = var.azure_vm_spokes
  source                        = "Azure/compute/azurerm"
  resource_group_name           = azurerm_resource_group.example.name
  vm_hostname                   = "${each.key}-avx-test-vm"
  nb_public_ip                  = 1
  remote_port                   = "22"
  vm_os_simple                  = "UbuntuServer"
  vnet_subnet_id                = module.azure_spoke[each.key].vnet.public_subnets[1].subnet_id
  delete_os_disk_on_termination = true
  custom_data                   = data.template_file.azure-init.rendered
  admin_password                = random_password.password.result
  enable_ssh_key                = false
  vm_size                       = var.test_instance_size
  tags = {
    environment = "aviatrix-poc"
    name        = "${each.key}-avx-test-vm"
  }
  depends_on = [azurerm_resource_group.example]
}

data "template_file" "azure-init" {
  template = file("${path.module}/azure-vm-config/azure_bootstrap.sh")
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Azure AKS Spoke
module "azure_aks_spoke" {
  source        = "terraform-aviatrix-modules/azure-spoke/aviatrix"
  version       = "3.0.0"
  name          = "aks"
  cidr          = var.azure_aks_spoke_cidr
  region        = var.azure_region1
  account       = var.azure_account_name
  ha_gw         = var.ha_enabled
  insane_mode   = true
  instance_size = var.instance_size
  transit_gw    = module.azure_transit_1.transit_gateway.gw_name
}

# Aviatrix AKS Resource Group
data "azurerm_subscription" "primary" {}
data "azurerm_subscription" "current" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "demo-aks"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.azure_region1
  dns_prefix          = "demoaks"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = module.azure_aks_spoke.vnet.public_subnets[1].subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = {
    Environment = "aviatrix-poc-aks"
  }

}

resource "azurerm_role_assignment" "aks" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

resource "local_file" "local-config-file" {
  content    = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename   = "${path.module}/kube_config/demo_kubeconfig_azure"
  depends_on = [azurerm_resource_group.example]
}

provider "helm" {
  alias = "azure"
  kubernetes {
    config_path = "${path.module}/kube_config/demo_kubeconfig_azure"
  }
}

resource "helm_release" "nginx" {
  provider   = helm.azure
  name       = "aks-nginx"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx"
  depends_on = [local_file.local-config-file]
}

# OCI Aviatrix Spokes
module "oci_app_spoke" {
  for_each   = var.oci_app_spokes
  source     = "terraform-aviatrix-modules/oci-spoke/aviatrix"
  version    = "3.0.0"
  name       = each.value.name
  cidr       = each.value.cidr
  ha_gw      = var.ha_enabled
  region     = each.value.region
  account    = var.oci_account_name
  transit_gw = module.azure_transit_1.transit_gateway.gw_name
}

module "oci_db_spoke" {
  for_each   = var.oci_db_spokes
  source     = "terraform-aviatrix-modules/oci-spoke/aviatrix"
  version    = "3.0.0"
  name       = each.value.name
  cidr       = each.value.cidr
  ha_gw      = var.ha_enabled
  region     = each.value.region
  account    = var.oci_account_name
  transit_gw = module.azure_transit_1.transit_gateway.gw_name
}

# OCI Network Security Groups
module "oci_app_network_sec_group" {
  for_each         = var.oci_app_spokes
  source           = "./modules/network-security-groups"
  compartment_ocid = var.compartment_ocid
  nsg_display_name = "${each.value.name}-nsg"
  nsg_whitelist_ip = module.oci_app_spoke[each.key].vcn.cidr
  vcn_id           = module.oci_app_spoke[each.key].vcn.vpc_id
  vcn_cidr_block   = module.oci_app_spoke[each.key].vcn.cidr
}

module "oci_db_network_sec_group" {
  for_each         = var.oci_db_spokes
  source           = "./modules/network-security-groups"
  compartment_ocid = var.compartment_ocid
  nsg_display_name = "${each.value.name}-nsg"
  nsg_whitelist_ip = module.oci_db_spoke[each.key].vcn.cidr
  vcn_id           = module.oci_db_spoke[each.key].vcn.vpc_id
  vcn_cidr_block   = module.oci_db_spoke[each.key].vcn.cidr
}

# OCI Flex Shape Test VM
module "flex_vm" {
  for_each         = var.oci_app_spokes
  source           = "./modules/flex-compute"
  vcn_id           = module.oci_app_spoke[each.key].vcn.vpc_id
  subnet_id        = module.oci_app_spoke[each.key].vcn.subnets[0].subnet_id
  nsg_ids          = [module.oci_app_network_sec_group[each.key].nsg_id]
  compartment_ocid = var.compartment_ocid
  ssh_public_key   = var.ssh_public_key
  display_name     = "${each.value.name}-avx-test-vm"
  region           = each.value.region
}

# Autonomous
module "autonomous_db" {
  for_each         = var.oci_db_spokes
  source           = "./modules/adb"
  adb_subnet_id    = module.oci_db_spoke[each.key].vcn.subnets[1].subnet_id
  adb_nsg_ids      = [module.oci_db_network_sec_group[each.key].nsg_id]
  cpu_core_count   = each.value.cpu_core_count
  size_in_tbs      = each.value.size_in_tbs
  db_workload      = each.value.db_workload
  db_name          = each.value.db_name
  compartment_ocid = var.compartment_ocid
}
