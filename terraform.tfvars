// Modify values below as needed
# Aviatrix Controller
#controller_ip = "REPLACE_ME"
#username      = "REPLACE_ME"
#password      = "REPLACE_ME"

# Azure and OCI Access Account Names defined in Controller
azure_account_name = "TM-Azure" # Replace this with your Access Account name
oci_account_name   = "TM-OCI"   # YOUR OCI ACCOUNT NAME IN CONTROLLER

# High Avaiability enabled
ha_enabled = true

# Aviatrix Gateway size
instance_size = "Standard_D3_v2"
# Test VM Kit
test_instance_size = "Standard_DS3_v2"

# Transit Gateway Network Variables
// Azure
azure_transit_cidr1   = "10.21.0.0/20"
azure_region1         = "East US"

// Azure Spokes
azure_vm_spokes      = { "avx-azure-test-vm" = "10.23.0.0/20" }
azure_aks_spoke_cidr = "10.22.0.0/20"

// OCI Spokes
oci_app_spokes = {
  app_spoke1 = {
    name   = "avx-oci-test-vm"
    cidr   = "10.3.0.0/16"
    region = "us-ashburn-1"
  }
}

// Autonomous DB Spokes
oci_db_spokes = {
  db_spoke1 = {
    name                = "adb"
    cidr                = "10.4.0.0/16"
    region              = "us-ashburn-1"
    cpu_core_count      = 1
    size_in_tbs         = 1
    db_name             = "avtxdb1"
    db_workload         = "DW"
    enable_auto_scaling = false
  }
}

// OCI Flex VMs
ssh_public_key   = "ssh-rsa AAxxxxxxxxxxx"
compartment_ocid = "ocid1.compartment.oc1..aaaaaaaahaxxxxxxxx"